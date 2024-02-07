
cd $1

echo "use $RUN;" > ./get_tab.sql
echo "show tables;" >> ./get_tab.sql

mysql -u web -p"modry_prizrak" < ./get_tab.sql | grep -v pok | grep -v dw | grep -v Table | grep -v neza | grep -v konfir | grep -v _fi > ./rsez.txt
mkdir ./OUT
for pac in `cat ./rsez.txt`
  do
   php ./id_to_file.php $pac > ./OUT/$pac
  done
date


ext="_fi"
echo "use $RUN;" > ./copy.sql

for file in `ls ./OUT/*`
  do
    bf=`basename $file`
    echo "drop table if exists $bf$ext;" >> ./copy.sql
    echo "create table $bf$ext like $bf;" >> ./copy.sql
    for line in `cat $file`
      do
        echo "insert $bf$ext SELECT * FROM $bf WHERE id=$line;" >> ./copy.sql
      done
    echo "--"
  done

mysql -u web -p"modry_prizrak" < ./copy.sql

