import pandas as pd
import re
import os
import shutil
import sys


def convert_txt(file_path):  # Raman
    try:
        txt_read_file = pd.read_csv(f"{file_path}", sep="\t")
        file_name = file_path.replace(".txt", "")
        processed_file_path = f"{file_name}.csv"
        txt_read_file.to_csv(processed_file_path, index=None, sep=",")
        return processed_file_path
    except:
        print(1)
        return 1


def convert_mon(file_path):  # Reflectance
    try:
        file_copy_path = f"{file_path}.copy"
        shutil.copy2(f"{file_path}", file_copy_path)

        with open(file_copy_path, encoding="Windows 1252") as reader, open(file_copy_path, "r+") as writer:
            for line in reader:
                if line.strip() and not line.startswith("//"):
                    line = f"{re.sub(' +', ' ', line).strip()}\n"
                    # .strip() seems to strip \n for some reason
                    writer.write(line)
            writer.truncate()
        mon_read_file = pd.read_csv(file_copy_path, sep=" ")
        file_name = file_path.replace(".mon", "")
        processed_file_path = f"{file_name}.csv"
        mon_read_file.to_csv(processed_file_path, index=None, sep=",")
        os.remove(file_copy_path)
        return processed_file_path
    except:
        print(1)
        return 1


def convert_spectable(file_path):  # LIBS
    try:
        file_copy_path = f"{file_path}.copy"
        shutil.copy2(f"{file_path}", file_copy_path)

        with open(file_copy_path) as reader, open(file_copy_path, "r+") as writer:
            for line in reader:
                if line.strip() and line[0].isdigit():
                    line = f"{re.sub(' +', ' ', line).strip()}\n"
                    line = line.replace("\t", " ")
                    line = line.replace(",", ".")
                    writer.write(line)
            writer.truncate()

        spectable_read_file = pd.read_csv(file_copy_path, sep=" ", dtype=float)
        file_name = file_path.replace(".spectable", "")
        processed_file_path = f"{file_name}.csv"
        spectable_read_file.to_csv(processed_file_path, index=None, sep=",")
        os.remove(file_copy_path)
        return processed_file_path
    except:
        print(1)
        return 1


def main():
    known_file_types = [".txt", ".mon", ".spectable", ".csv"]

    csvs_ignored = 0

    try:
        file_path = sys.argv[1]
    except:
        print(1)
        return 1

    file_extension = ""
    for file_type in known_file_types:
        if file_path.endswith(file_type):
            file_extension = file_type
            if file_extension == ".csv":
                # ignore existing and/or generated .csv's
                csvs_ignored += 1
            elif file_extension == ".txt":
                print(convert_txt(file_path))
            elif file_extension == ".mon":
                print(convert_mon(file_path))
            elif file_extension == ".spectable":
                print(convert_spectable(file_path))
            else:
                pass
    if not file_extension:
        print(1)
        return 1


if __name__ == "__main__":
    main()
