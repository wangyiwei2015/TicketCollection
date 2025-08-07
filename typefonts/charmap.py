import sys
from fontTools.ttLib import TTFont

font_path = sys.argv[1]
output_txt = sys.argv[2]

font = TTFont(font_path)
chars = set()
for table in font['cmap'].tables:
    for codepoint in table.cmap.keys():
        try:
            chars.add(chr(codepoint))
        except (ValueError, OverflowError, fontTools.subset.Subsetter.MissingGlyphsSubsettingError):
            pass  # 跳过无效字符

with open(output_txt, 'w', encoding='utf-8') as f:
    f.write(''.join(sorted(chars)))

