set -e

# make dbgen
cd ../dbgen && make

# clone dbgen to DATADIR
ssh sdw1 'cd /data1 && rm -rf dbgen' 
scp -r ../dbgen sdw1:/data1
ssh sdw2 'cd /data1 && rm -rf dbgen' 
scp -r ../dbgen sdw2:/data1

# run dbgen on each machine
ssh sdw1 'cd /data1/dbgen && ./dbgen -s 2000 -S 1 -C 30' & 
ssh sdw1 'cd /data1/dbgen && ./dbgen -s 2000 -S 2 -C 30' & 
ssh sdw1 'cd /data1/dbgen && ./dbgen -s 2000 -S 3 -C 30' & 
ssh sdw1 'cd /data1/dbgen && ./dbgen -s 2000 -S 4 -C 30' & 
ssh sdw1 'cd /data1/dbgen && ./dbgen -s 2000 -S 5 -C 30' & 
ssh sdw1 'cd /data1/dbgen && ./dbgen -s 2000 -S 6 -C 30' & 
ssh sdw1 'cd /data1/dbgen && ./dbgen -s 2000 -S 7 -C 30' & 
ssh sdw1 'cd /data1/dbgen && ./dbgen -s 2000 -S 8 -C 30' & 
ssh sdw1 'cd /data1/dbgen && ./dbgen -s 2000 -S 9 -C 30' & 
ssh sdw1 'cd /data1/dbgen && ./dbgen -s 2000 -S 10 -C 30' & 
ssh sdw1 'cd /data1/dbgen && ./dbgen -s 2000 -S 11 -C 30' & 
ssh sdw1 'cd /data1/dbgen && ./dbgen -s 2000 -S 12 -C 30' & 
ssh sdw1 'cd /data1/dbgen && ./dbgen -s 2000 -S 13 -C 30' & 
ssh sdw1 'cd /data1/dbgen && ./dbgen -s 2000 -S 14 -C 30' & 
ssh sdw1 'cd /data1/dbgen && ./dbgen -s 2000 -S 15 -C 30' & 
ssh sdw2 'cd /data1/dbgen && ./dbgen -s 2000 -S 16 -C 30' & 
ssh sdw2 'cd /data1/dbgen && ./dbgen -s 2000 -S 17 -C 30' & 
ssh sdw2 'cd /data1/dbgen && ./dbgen -s 2000 -S 18 -C 30' & 
ssh sdw2 'cd /data1/dbgen && ./dbgen -s 2000 -S 19 -C 30' & 
ssh sdw2 'cd /data1/dbgen && ./dbgen -s 2000 -S 20 -C 30' & 
ssh sdw2 'cd /data1/dbgen && ./dbgen -s 2000 -S 21 -C 30' & 
ssh sdw2 'cd /data1/dbgen && ./dbgen -s 2000 -S 22 -C 30' & 
ssh sdw2 'cd /data1/dbgen && ./dbgen -s 2000 -S 23 -C 30' & 
ssh sdw2 'cd /data1/dbgen && ./dbgen -s 2000 -S 24 -C 30' & 
ssh sdw2 'cd /data1/dbgen && ./dbgen -s 2000 -S 25 -C 30' & 
ssh sdw2 'cd /data1/dbgen && ./dbgen -s 2000 -S 26 -C 30' & 
ssh sdw2 'cd /data1/dbgen && ./dbgen -s 2000 -S 27 -C 30' & 
ssh sdw2 'cd /data1/dbgen && ./dbgen -s 2000 -S 28 -C 30' & 
ssh sdw2 'cd /data1/dbgen && ./dbgen -s 2000 -S 29 -C 30' & 
ssh sdw2 'cd /data1/dbgen && ./dbgen -s 2000 -S 30 -C 30' & 
wait

# push tbl files to s3://vitessedata/tpch/*
aws s3 rm s3://vitessedata/tpch/ --recursive
ssh sdw1 'cd /data1/dbgen && rm -f list* && ls -1 *tbl* > list && spit -n 8 list list' & 
ssh sdw2 'cd /data1/dbgen && rm -f list* && ls -1 *tbl* > list && spit -n 8 list list' & 
wait

ssh sdw1 'cd /data1/dbgen && 
                 ( for i in list??; do 
                     ( for j in $(< $i); do aws s3 cp $j s3://vitessedata/tpch/$j ; done ) & 
                   done ) && 
             wait'  &
ssh sdw2 'cd /data1/dbgen && 
                 ( for i in list??; do 
                     ( for j in $(< $i); do aws s3 cp $j s3://vitessedata/tpch/$j ; done ) & 
                   done ) && 
             wait'  &

wait

