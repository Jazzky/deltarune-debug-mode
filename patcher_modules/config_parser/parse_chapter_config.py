from ..setup import ALL_CHAPTERS

def parse_chapter_config(chap_list):
    chap_list = list(set(chap_list))

    if (min(chap_list) < 0):
        if (max(chap_list) >= 0):
            print(f"Warning: invalid chapter values. Skipping.")
            print("Rules: only positive or negative numbers but no mix")
            return ({})

        parsed = ALL_CHAPTERS.copy()
        for chap in chap_list:
            parsed.remove(-chap)
        chap_list = parsed

    return chap_list
