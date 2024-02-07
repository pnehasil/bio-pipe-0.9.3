
load_params "$@"
. ${WOR_LIB}/bioenv

log "### Alela part 2.3 ###"

[ -d ${CNV_KIT_DIR} ] || error_exit "${CNV_KIT_DIR} not found"
[ -d ${RG_DIR} ] || error_exit "${RG_DIR} not found"
[ -d ${BED_DIR} ] || error_exit "${BED_DIR} not found"
[ -d ${BEDTOOLS_DIR} ] || error_exit "${BEDTOOLS_DIR} not found"
[ -d ${PINDEL_DIR} ] || error_exit "${PINDEL_DIR} not found"


log "Create dohromady"

cat ${FPIN_DIR}/*_D > ${FPIN_DIR}/dohromady_D.txt
cat ${FPIN_DIR}/*_SI > ${FPIN_DIR}/dohromady_SI.txt
cat ${FPIN_DIR}/*_RP > ${FPIN_DIR}/dohromady_RP.txt
cat ${FPIN_DIR}/*_LI > ${FPIN_DIR}/dohromady_LI.txt
cat ${FPIN_DIR}/*_TD > ${FPIN_DIR}/dohromady_TD.txt
cat ${FPIN_DIR}/*_INV > ${FPIN_DIR}/dohromady_INV.txt
cat ${FPIN_DIR}/*_INT_final > ${FPIN_DIR}/dohromady_INT_final.txt
cat ${FPIN_DIR}/*_CloseEndMapped > ${FPIN_DIR}/dohromady_Close.txt
cat ${FPIN_DIR}/*_BP > ${FPIN_DIR}/dohromady_BP.txt

log "Grep dohromady"

grep chr ${FPIN_DIR}/dohromady_D.txt > ${FPIN_DIR}/dohromady_d_f.txt
grep chr ${FPIN_DIR}/dohromady_RP.txt > ${FPIN_DIR}/dohromady_rp_f.txt
grep chr ${FPIN_DIR}/dohromady_SI.txt > ${FPIN_DIR}/dohromady_si_f.txt
grep chr ${FPIN_DIR}/dohromady_INV.txt > ${FPIN_DIR}/dohromady_inv_f.txt
grep chr ${FPIN_DIR}/dohromady_TD.txt > ${FPIN_DIR}/dohromady_td_f.txt
grep chr ${FPIN_DIR}/dohromady_INT_final.txt > ${FPIN_DIR}/dohromady_int_f.txt
grep chr ${FPIN_DIR}/dohromady_Close.txt > ${FPIN_DIR}/dohromady_close_f.txt
grep chr ${FPIN_DIR}/dohromady_BP.txt > ${FPIN_DIR}/dohromady_bp_f.txt

log "tr dohromady"

tr ' ' \\t < ${FPIN_DIR}/dohromady_d_f.txt> ${FPIN_DIR}/final_d.txt
tr ' ' \\t < ${FPIN_DIR}/dohromady_rp_f.txt> ${FPIN_DIR}/final_rp_f.txt
tr ' ' \\t < ${FPIN_DIR}/dohromady_si_f.txt> ${FPIN_DIR}/final_si_f.txt
tr ' ' \\t < ${FPIN_DIR}/dohromady_inv_f.txt> ${FPIN_DIR}/final_inv_f.txt
tr ' ' \\t < ${FPIN_DIR}/dohromady_td_f.txt> ${FPIN_DIR}/final_td_f.txt
tr ' ' \\t < ${FPIN_DIR}/dohromady_int_f.txt> ${FPIN_DIR}/final_int_f.txt
tr ' ' \\t < ${FPIN_DIR}/dohromady_close_f.txt> ${FPIN_DIR}/final_close_f.txt
tr ' ' \\t < ${FPIN_DIR}/dohromady_bp_f.txt> ${FPIN_DIR}/final_bp_f.txt

log "cut final"

cut -f 8,10-11 ${FPIN_DIR}/final_d.txt > ${FPIN_DIR}/koord_d.txt
cut -f 8,10-11 ${FPIN_DIR}/final_si_f.txt > ${FPIN_DIR}/koord_si_f.txt
cut -f 8,10-11 ${FPIN_DIR}/final_td_f.txt > ${FPIN_DIR}/koord_td_f.txt

log "paste final"

paste ${FPIN_DIR}/koord_d.txt ${FPIN_DIR}/final_d.txt > ${FPIN_DIR}/final_d.bed
paste ${FPIN_DIR}/koord_si_f.txt ${FPIN_DIR}/final_si_f.txt > ${FPIN_DIR}/final_si_f.bed
paste ${FPIN_DIR}/koord_td_f.txt ${FPIN_DIR}/final_td_f.txt > ${FPIN_DIR}/final_td_f.bed

log "bedtools final"

${BEDTOOLS_DIR}/bedtools intersect -a ${FPIN_DIR}/final_d.bed -b ${BED_DIR}/koord_NM_jmeno.bed -wb > ${FPIN_DIR}/final_d_a.bed
${BEDTOOLS_DIR}/bedtools intersect -a ${FPIN_DIR}/final_si_f.bed -b ${BED_DIR}/koord_NM_jmeno.bed -wb > ${FPIN_DIR}/final_si_f_a.bed
${BEDTOOLS_DIR}/bedtools intersect -a ${FPIN_DIR}/final_td_f.bed -b ${BED_DIR}/koord_NM_jmeno.bed -wb > ${FPIN_DIR}/final_td_f_a.bed

log "VOLNA_CZE"

#VOLNA_CZE
${BEDTOOLS_DIR}/bedtools intersect -a ${FPIN_DIR}/final_d.bed -b ${BED_DIR}/koord_NM_jmeno_CZE2.bed -wb > ${FPIN_DIR}/final_d_a.bed
${BEDTOOLS_DIR}/bedtools intersect -a ${FPIN_DIR}/final_si_f.bed -b ${BED_DIR}/koord_NM_jmeno_CZE2.bed -wb > ${FPIN_DIR}/final_si_f_a.bed
${BEDTOOLS_DIR}/bedtools intersect -a ${FPIN_DIR}/final_td_f.bed -b ${BED_DIR}/koord_NM_jmeno_CZE2.bed -wb > ${FPIN_DIR}/final_td_f_a.bed

log "CZMELAK"

#CZMELAK
${BEDTOOLS_DIR}/bedtools intersect -a ${FPIN_DIR}/final_d.bed -b ${BED_DIR}/koord_nm_jm.bed -wb > ${FPIN_DIR}/final_d_a.bed
${BEDTOOLS_DIR}/bedtools intersect -a ${FPIN_DIR}/final_si_f.bed -b ${BED_DIR}/koord_nm_jm.bed -wb > ${FPIN_DIR}/final_si_f_a.bed
${BEDTOOLS_DIR}/bedtools intersect -a ${FPIN_DIR}/final_td_f.bed -b ${BED_DIR}/koord_nm_jm.bed -wb > ${FPIN_DIR}/final_td_f_a.bed

${BEDTOOLS_DIR}/bedtools intersect -a ${FPIN_DIR}/final_si_f_a.bed -b ${BED_DIR}/exony_koor_2u.txt -wb -loj > ${FPIN_DIR}/inzerce.bed
${BEDTOOLS_DIR}/bedtools intersect -a ${FPIN_DIR}/final_d_a.bed -b ${BED_DIR}/exony_koor_2u.txt -wb -loj > ${FPIN_DIR}/delece.bed
${BEDTOOLS_DIR}/bedtools intersect -a ${FPIN_DIR}/final_td_f_a.bed -b ${BED_DIR}/exony_koor_2u.txt -wb -loj > ${FPIN_DIR}/tandem.bed

log "shell upravy"

cat ${FPIN_DIR}/*_a.bed > ${FPIN_DIR}/pindel.bed
sort ${FPIN_DIR}/pindel.bed > ${FPIN_DIR}/pindel_sort.bed
awk '{print  $1 "_" $2 "_" $3 "_" $5 "_" $6 }' ${FPIN_DIR}/pindel_sort.bed > ${FPIN_DIR}/PINDEL.bed
paste ${FPIN_DIR}/PINDEL.bed ${FPIN_DIR}/pindel_sort.bed > ${FPIN_DIR}/UBEO.bed
awk '$7>9{ print $0} ' ${FPIN_DIR}/UBEO.bed > ${FPIN_DIR}/UBEO_9.bed
grep -Fwf  ${BED_DIR}/pouze_NM_4.txt ${FPIN_DIR}/UBEO_9.bed > ${FPIN_DIR}/UBEO_NM.bed
sort  -n ${FPIN_DIR}/UBEO_NM.bed  | cut -f1 |uniq -c > ${FPIN_DIR}/pocet.txt
awk -v OFS="\t" '$1=$1' ${FPIN_DIR}/pocet.txt > ${FPIN_DIR}/meypocet.txt

cut -f1 ${FPIN_DIR}/meypocet.txt > ${FPIN_DIR}/abs.txt
cut -f2 ${FPIN_DIR}/meypocet.txt > ${FPIN_DIR}/kor.txt
paste ${FPIN_DIR}/kor.txt ${FPIN_DIR}/abs.txt > ${FPIN_DIR}/poradi.txt
sort -k1 ${FPIN_DIR}/UBEO_NM.bed > ${FPIN_DIR}/UBEO_s.txt
sort -k1 ${FPIN_DIR}/poradi.txt > ${FPIN_DIR}/poradi_s.txt
join -1 1 -2 1 ${FPIN_DIR}/poradi_s.txt ${FPIN_DIR}/UBEO_s.txt > ${FPIN_DIR}/final_UBEO.bed
awk '$2<15{ print $0} ' ${FPIN_DIR}/final_UBEO.bed | sed s'/ /\t/g' > ${FPIN_DIR}/final_UBEO_filtr.txt




