function fn() {
   try {
      var env = karate.env;
      karate.log('karate.env system property was:', env);
      if (!env) {
         env = 'qa';
         karate.log('Environment defaulted to:', env);
      }

      karate.configure('ssl', true);
      karate.configure('lowerCaseResponseHeaders', true);

      var config = {
         Username: '',
         Password: '',
      };
      config.testsetpath = '../../../TestSuite/';

      switch (env) {
      case 'qa':
         config.baseUrl = 'https://google.com';
         break;
      case 'uat':
         config.baseUrl = ''
         break;
      }

      karate.configure('connectTimeout', 10000);
      karate.configure('readTimeout', 20000);
      return {
         config: config,
         env: env
      };
   }
   catch (err) {
      karate.log(err);
      return {}
   }
}