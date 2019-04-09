docker run --rm --name hostA1 --hostname hostA1 --network netA --privileged -d edtasixm11/net18:nethost
docker run --rm --name hostA2 --hostname hostA2 --network netA --privileged -d edtasixm11/net18:nethost
docker run --rm --name hostB1 --hostname hostB1 --network netB --privileged -d edtasixm11/net18:nethost
docker run --rm --name hostB2 --hostname hostB2 --network netB --privileged -d edtasixm11/net18:nethost
