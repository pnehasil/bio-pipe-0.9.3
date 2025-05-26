
import sys

input_vcf = sys.argv[1]
output_vcf = sys.argv[2]

with open(input_vcf, 'r') as infile, open(output_vcf, 'w') as outfile:
    for line in infile:
        if line.startswith("#"):
            outfile.write(line)
            continue

        cols = line.strip().split('\t')

        info_fields = cols[7].split(';')
        eff_entries = []
        other_info_fields = []

        for field in info_fields:
            if field.startswith("EFF="):
                eff_entries = field[4:].split(',')
            else:
                other_info_fields.append(field)

        # Zjisti, zda alespoň jedna anotace obsahuje gen CDKN2A
        contains_cdkn2a = any('CDKN2A' in eff for eff in eff_entries)

        # Pokud existuje více EFF anotací a jedna z nich obsahuje CDKN2A, rozděl řádek
        if eff_entries and contains_cdkn2a:
            for eff in eff_entries:
                if 'CDKN2A' in eff:
                    new_cols = cols.copy()
                    new_info = other_info_fields.copy()
                    new_info.append("EFF=" + eff)
                    new_cols[7] = ';'.join(new_info)
                    outfile.write('\t'.join(new_cols) + '\n')
        else:
            outfile.write(line)

