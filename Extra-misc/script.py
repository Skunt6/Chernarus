import json


# Function to categorize into small, medium, and large calibers
def categorize_by_size(guns):
    small_calibers = ["9x19", "4.6x30", "5.7x28", "380", "545", "9x39", "762x25", ".45", ".357", ".44"]
    medium_calibers = ["300ac", "556", "762x39", "762x51", "308", "30-06", "45-70", "762x54", "408"]
    large_calibers = [".50 cal", "12.7x55mm", "14.5x114", "338", "500 s&w", "shotgun"]
    
    categorized_guns = {"small": [], "medium": [], "large": []}
    
    for gun in guns:
        caliber = gun["caliber"]
        if isinstance(caliber, list):
            for cal in caliber:
                if cal in small_calibers:
                    categorized_guns["small"].append(gun["name"])
                elif cal in medium_calibers:
                    categorized_guns["medium"].append(gun["name"])
                elif cal in large_calibers:
                    categorized_guns["large"].append(gun["name"])
        else:
            if caliber in small_calibers:
                categorized_guns["small"].append(gun["name"])
            elif caliber in medium_calibers:
                categorized_guns["medium"].append(gun["name"])
            elif caliber in large_calibers:
                categorized_guns["large"].append(gun["name"])

    return categorized_guns


# The manually categorized guns list with their calibers
guns_with_calibers = [
    {"name": "ar15", "caliber": "300ac"},
    {"name": "m4 carbine", "caliber": ["300ac", "556"]},
    {"name": "aa12", "caliber": "shotgun"},
    {"name": "honey badger", "caliber": "300ac"},
    {"name": "agram 2000", "caliber": "9x19"},
    {"name": "ak103", "caliber": "762x39"},
    {"name": "ak12", "caliber": "545x39"},
    {"name": "ak19", "caliber": "556"},
    {"name": "ak308", "caliber": "308"},
    {"name": "aps", "caliber": "380"},
    {"name": "as50", "caliber": ".50 cal"},
    {"name": "ash-12.7", "caliber": "12.7x55mm"},
    {"name": "atac m98b", "caliber": "338"},
    {"name": "aug a3", "caliber": "556"},
    {"name": "awm", "caliber": "338"},
    {"name": "chiappa rhino", "caliber": "357"},
    {"name": "cz850", "caliber": "556"},
    {"name": "t5000", "caliber": "338"},
    {"name": "dlv-10 m2", "caliber": "338"},
    {"name": "famas", "caliber": "556"},
    {"name": "fn scar", "caliber": "556"},
    {"name": "fort12", "caliber": "9x19"},
    {"name": "fr-f2", "caliber": "762x51"},
    {"name": "m82 barret", "caliber": ".50 cal"},
    {"name": "gevar mk-3", "caliber": "338"},
    {"name": "gm6 lynx", "caliber": ".50 cal"},
    {"name": "hk416", "caliber": "556"},
    {"name": "hk417", "caliber": "762x51"},
    {"name": "Ia2", "caliber": "556"},
    {"name": "jjfu nomad", "caliber": "556"},
    {"name": "kac pdw", "caliber": "300ac"},
    {"name": "kh9", "caliber": "9x19"},
    {"name": "kivaari", "caliber": "338"},
    {"name": "vector", "caliber": [".45", "9x19"]},
    {"name": "lvoa", "caliber": "556"},
    {"name": "m110", "caliber": "308"},
    {"name": "m14 battle rifle", "caliber": "762x51"},
    {"name": "browning rifle", "caliber": "30-06"},
    {"name": "m1a", "caliber": "308"},
    {"name": "m1garand", "caliber": "30-06"},
    {"name": "m200", "caliber": "408"},
    {"name": "m249", "caliber": "556"},
    {"name": "m96", "caliber": "408"},
    {"name": "mar10", "caliber": "338"},
    {"name": "marlin 1895", "caliber": "45-70"},
    {"name": "mk12 mod 1", "caliber": "556"},
    {"name": "mk18", "caliber": "556"},
    {"name": "model 500", "caliber": "500 s&w"},
    {"name": "mp7", "caliber": "4.6x30"},
    {"name": "mp9", "caliber": "9x19"},
    {"name": "p90", "caliber": "5.7x28"},
    {"name": "ppsh", "caliber": "762x25"},
    {"name": "ppskn 42", "caliber": "762x39"},
    {"name": "Remington acr", "caliber": "556"},
    {"name": "Remington model 700", "caliber": "308"},
    {"name": "rpd", "caliber": "762x39"},
    {"name": "rpk-16", "caliber": "545"},
    {"name": "sa80", "caliber": "556"},
    {"name": "sa58", "caliber": "308"},
    {"name": "saint victor", "caliber": "556"},
    {"name": "sg550", "caliber": "556"},
    {"name": "sig sauer mpx", "caliber": "9x19"},
    {"name": "s&m model 629", "caliber": ".44"},
    {"name": "sn auto shotgun", "caliber": "shotgun"},
    {"name": "sn glock19", "caliber": "9x19"},
    {"name": "sn m870", "caliber": "shotgun"},
    {"name": "sn m9", "caliber": "9x19"},
    {"name": "sn mp443", "caliber": "9x19"},
    {"name": "sn usp", "caliber": ".45"},
    {"name": "aek545", "caliber": "545"},
    {"name": "ax50", "caliber": ".50 cal"},
    {"name": "m24a3", "caliber": "338"},
    {"name": "rsass", "caliber": "308"},
    {"name": "pkp", "caliber": "762x54"},
    {"name": "scar-h", "caliber": "308"},
    {"name": "sr25", "caliber": "762x51"},
    {"name": "alligator", "caliber": "14.5x114"},
    {"name": "spas12", "caliber": "shotgun"},
    {"name": "sr3", "caliber": "9x39"},
    {"name": "srs a2", "caliber": "338"},
    {"name": "sten mk 3", "caliber": "9x19"},
    {"name": "tac 21", "caliber": "338"},
    {"name": "tar21", "caliber": "556"},
    {"name": "tec9", "caliber": "9x19"},
    {"name": "Thompson mk2", "caliber": ".45"},
    {"name": "tp82", "caliber": "shotgun"},
    {"name": "trench gun", "caliber": "shotgun"},
    {"name": "ultimax 100", "caliber": "556"},
    {"name": "uzi", "caliber": "9x19"},
    {"name": "vepr", "caliber": "762x39"},
    {"name": "vityaz pp19 01", "caliber": "9x19"},
    {"name": "vr80", "caliber": "shotgun"},
    {"name": "zastava m48", "caliber": "308"},
    {"name": "zastava m59/66 pap", "caliber": "762x39"},
    {"name": "zastava m76", "caliber": "308"}
]

# Categorize the guns
categorized_guns = categorize_by_size(guns_with_calibers)

file_path = r'C:\Users\rt603\projects\Dayz-servers\Chernarus\Extra-misc\categorized_guns.json'
try:
    with open(file_path, 'w') as json_file:
        json.dump(categorized_guns, json_file, indent=4)
    print(f"Categorized guns saved to '{file_path}'.")
except Exception as e:
    print(f"An error occurred: {e}")

# This will output the categorized results to the console as well
print(categorized_guns)