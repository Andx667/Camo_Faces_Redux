#!/usr/bin/env python3

# CAMO GENERATOR - PAINT LAYER MODEL
# ---------------------------------
# Recovers a camo scheme's paint layer from the textures the mod already ships, so the same
# scheme can be applied to a head nobody painted by hand.
#
# Every painted pixel is modelled as
#
#     camo = base * (1 - alpha) + u          where u = alpha * paint_colour
#
# alpha and u belong to the *scheme*, not to any one face, because every Man_A3 head shares a
# single UV layout - a scheme's artwork lands on exactly the same pixels whichever face it is
# painted on. Fitting across faces with different skin tones is what separates alpha from u:
# with one face alone the two are indistinguishable.
#
# Centring the per-face values reduces the fit to a closed form, so the whole 1024x1024 image
# solves at once with no iteration. Accumulators are streamed one face at a time, which keeps
# memory flat and lets a face's contribution be subtracted again for hold-one-out validation.

import numpy as np
from PIL import Image

# Mean paint delta (in 0-255 levels) over which the layer fades in. The shipped textures carry
# DXT round-trip noise; without this the fit bakes that noise in as a faint tint over the whole
# head. The ramp keeps genuine soft airbrush edges instead of hard-clipping them.
NOISE_FLOOR, PAINT_FLOOR = 4.0, 9.0


def load(path):
    """A texture as float RGB, shape (H, W, 3)."""
    return np.asarray(Image.open(path).convert("RGB")).astype(np.float64)


def save(path, img):
    Image.fromarray(np.clip(img, 0, 255).round().astype(np.uint8)).save(path)


class Fit:
    """Streaming least-squares accumulator over faces."""

    def __init__(self, shape=(1024, 1024, 3)):
        self.n = 0
        self.s_b = np.zeros(shape)
        self.s_d = np.zeros(shape)
        self.s_bb = np.zeros(shape)
        self.s_bd = np.zeros(shape)
        self.s_absd = np.zeros(shape[:2])

    def add(self, base, camo, sign=1):
        d = camo - base
        self.n += sign
        self.s_b += sign * base
        self.s_d += sign * d
        self.s_bb += sign * base * base
        self.s_bd += sign * base * d
        self.s_absd += sign * np.abs(d).max(axis=2)
        return self

    def remove(self, base, camo):
        """Undo one add - used to leave a face out without refitting from scratch."""
        return self.add(base, camo, sign=-1)

    def solve(self):
        """Returns alpha (H, W) and u (H, W, 3)."""
        n = self.n
        bbar, dbar = self.s_b / n, self.s_d / n
        num = -(self.s_bd - n * bbar * dbar).sum(axis=2)
        den = (self.s_bb - n * bbar * bbar).sum(axis=2)
        well = den > 1e-3
        a = np.zeros_like(num)
        np.divide(num, den, out=a, where=well)
        a = np.clip(a, 0.0, 1.0)
        a[~well] = 0.0          # no tonal spread to learn from -> pure additive transfer
        u = dbar + a[..., None] * bbar

        strength = np.clip((self.s_absd / n - NOISE_FLOOR) / (PAINT_FLOOR - NOISE_FLOOR), 0.0, 1.0)
        return a * strength, u * strength[..., None]


def apply(base, alpha, u):
    """Composite a fitted paint layer onto a base face."""
    return np.clip(base * (1.0 - alpha[..., None]) + u, 0, 255)
