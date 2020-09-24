function readTestCase(args){
     try{
         karate.log('reading test data file...')
         var readfile = Java.type('ExcelIO.readFile');
         var dataStream = new readfile();
         var testinfo={
             testdata:''
         };
         testinfo.testdata = dataStream.getTestData(args);
         return testinfo;
     }catch(err){
        karate.log('error is :', err);
        return {err:err};
     }
 }

