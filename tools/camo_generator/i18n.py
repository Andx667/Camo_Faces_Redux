#!/usr/bin/env python3

# CAMO GENERATOR - LANGUAGES
# --------------------------
# The stringtable languages of Arma 3 (every tag its own stringtables carry, besides Original and
# English) and the scheme labels the face names are built from. A face's name in a language is
# "<surname> <scheme label>", the surname being what the game itself calls the head in that language
# (data/names_i18n.json) - so a Russian player sees the same spelling Bohemia uses for that head.
#
# German and English stay where they always were: the surname/scheme pairs in faces.py and
# data/names.json. Everything else comes from here and data/names_i18n.json.

# stringtable tags in the order they are written after English and German
LANG_TAGS = [
    "Czech", "French", "Spanish", "Latin", "Italian", "Polish", "Portuguese", "Russian", "Ukrainian",
    "Bulgarian", "Slovak", "Hungarian", "Turkish", "Korean", "Japanese", "Chinese", "Chinesesimp",
]

# scheme suffix -> label in each language ("Latin" - Latin American Spanish - reuses the Spanish one)
SCHEME_I18N = {
    "BWTarn": {
        "Czech": "BW kamufláž", "French": "BW camouflage", "Spanish": "BW camuflaje", "Italian": "BW mimetica",
        "Polish": "BW kamuflaż", "Portuguese": "BW camuflagem", "Russian": "BW камуфляж", "Ukrainian": "BW камуфляж",
        "Bulgarian": "BW камуфлаж", "Slovak": "BW kamufláž", "Hungarian": "BW álcázás", "Turkish": "BW kamuflaj",
        "Korean": "BW 위장", "Japanese": "BW 迷彩", "Chinese": "BW 偽裝", "Chinesesimp": "BW 伪装",
    },
    "BWStripes": {
        "Czech": "BW pruhy", "French": "BW rayures", "Spanish": "BW rayas", "Italian": "BW strisce",
        "Polish": "BW pasy", "Portuguese": "BW listras", "Russian": "BW полосы", "Ukrainian": "BW смуги",
        "Bulgarian": "BW ивици", "Slovak": "BW pruhy", "Hungarian": "BW csíkok", "Turkish": "BW şeritler",
        "Korean": "BW 줄무늬", "Japanese": "BW ストライプ", "Chinese": "BW 條紋", "Chinesesimp": "BW 条纹",
    },
    "Black": {
        "Czech": "Černá", "French": "Noir", "Spanish": "Negro", "Italian": "Nero",
        "Polish": "Czarny", "Portuguese": "Preto", "Russian": "Чёрный", "Ukrainian": "Чорний",
        "Bulgarian": "Черен", "Slovak": "Čierna", "Hungarian": "Fekete", "Turkish": "Siyah",
        "Korean": "검정", "Japanese": "ブラック", "Chinese": "黑色", "Chinesesimp": "黑色",
    },
    "Serbian": {
        "Czech": "Srbská", "French": "Serbe", "Spanish": "Serbio", "Italian": "Serbo",
        "Polish": "Serbski", "Portuguese": "Sérvio", "Russian": "Сербский", "Ukrainian": "Сербський",
        "Bulgarian": "Сръбски", "Slovak": "Srbská", "Hungarian": "Szerb", "Turkish": "Sırp",
        "Korean": "세르비아", "Japanese": "セルビア", "Chinese": "塞爾維亞", "Chinesesimp": "塞尔维亚",
    },
    "USStripes": {
        "Czech": "US pruhy", "French": "US rayures", "Spanish": "US rayas", "Italian": "US strisce",
        "Polish": "US pasy", "Portuguese": "US listras", "Russian": "US полосы", "Ukrainian": "US смуги",
        "Bulgarian": "US ивици", "Slovak": "US pruhy", "Hungarian": "US csíkok", "Turkish": "US şeritler",
        "Korean": "US 줄무늬", "Japanese": "US ストライプ", "Chinese": "US 條紋", "Chinesesimp": "US 条纹",
    },
    "USStains": {
        "Czech": "US skvrny", "French": "US taches", "Spanish": "US manchas", "Italian": "US macchie",
        "Polish": "US plamy", "Portuguese": "US manchas", "Russian": "US пятна", "Ukrainian": "US плями",
        "Bulgarian": "US петна", "Slovak": "US škvrny", "Hungarian": "US foltok", "Turkish": "US lekeler",
        "Korean": "US 얼룩", "Japanese": "US ステイン", "Chinese": "US 斑點", "Chinesesimp": "US 斑点",
    },
    "USFlash": {
        "Czech": "US záblesk", "French": "US flash", "Spanish": "US destellos", "Italian": "US flash",
        "Polish": "US błysk", "Portuguese": "US flash", "Russian": "US вспышка", "Ukrainian": "US спалах",
        "Bulgarian": "US светкавица", "Slovak": "US záblesk", "Hungarian": "US villanás", "Turkish": "US flaş",
        "Korean": "US 플래시", "Japanese": "US フラッシュ", "Chinese": "US 閃光", "Chinesesimp": "US 闪光",
    },
    "SnowStripes": {
        "Czech": "Sněhové pruhy", "French": "Rayures neige", "Spanish": "Rayas de nieve", "Italian": "Strisce neve",
        "Polish": "Śnieżne pasy", "Portuguese": "Listras de neve", "Russian": "Снежные полосы", "Ukrainian": "Снігові смуги",
        "Bulgarian": "Снежни ивици", "Slovak": "Snehové pruhy", "Hungarian": "Havas csíkok", "Turkish": "Kar şeritleri",
        "Korean": "눈 줄무늬", "Japanese": "スノーストライプ", "Chinese": "雪地條紋", "Chinesesimp": "雪地条纹",
    },
}


def scheme_label(suffix, tag):
    """A scheme's label in a stringtable language; Latin American Spanish reuses the Spanish one."""
    return SCHEME_I18N[suffix]["Spanish" if tag == "Latin" else tag]
