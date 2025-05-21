import sys

if len(sys.argv) != 3:
    print("Použití: python rozdel_vcf_eff.py vstup.vcf vystup.vcf")
    sys.exit(1)

input_vcf = sys.argv[1]
output_vcf = sys.argv[2]

with open(input_vcf, 'r') as infile, open(output_vcf, 'w') as outfile:
    for line in infile:
        if line.startswith("#"):
            outfile.write(line)
            continue

        cols = line.strip().split('\t')

        # Rozděl pole INFO na části
        info_fields = cols[7].split(';')
        eff_entries = []
        other_info_fields = []

        for field in info_fields:
            if field.startswith("EFF="):
                eff_entries = field[4:].split(',')
            else:
                other_info_fields.append(field)

        # Pokud existuje více EFF anotací, vytvoř jeden řádek na každou
        if eff_entries:
            for eff in eff_entries:
                new_cols = cols.copy()
                new_info = other_info_fields.copy()
                new_info.append("EFF=" + eff)
                new_cols[7] = ';'.join(new_info)
                outfile.write('\t'.join(new_cols) + '\n')
        else:
            outfile.write(line)

