////////////////////// Creating Objects ///////////////////////
(async () => {
    const myNewObject = new Parse.Object('receitas');
    myNewObject.set('title_receita', 'A string');
    myNewObject.set('sugestao_chef', 'A string');
    myNewObject.set('user', Parse.User.current());
    myNewObject.set('categorie', new Parse.Object("categories"));
    myNewObject.set('ingredients', new Parse.Object("ingredients"));
    try {
      const result = await myNewObject.save();
      // Access the Parse Object attributes using the .GET method
      console.log('receitas created', result);
    } catch (error) {
      console.error('Error while creating receitas: ', error);
    }
  })();
  ///////////////// Reading Objects ///////////////
  (async () => {
    const receitas = Parse.Object.extend('receitas');
    const query = new Parse.Query(receitas);
    // You can also query by using a parameter of an object
    // query.equalTo('objectId', 'xKue915KBG');
    try {
      const results = await query.find();
      for (const object of results) {
        // Access the Parse Object attributes using the .GET method
        const title_receita = object.get('title_receita')
        const sugestao_chef = object.get('sugestao_chef')
        const user = object.get('user')
        const categorie = object.get('categorie')
        const ingredients = object.get('ingredients')
        console.log(title_receita);
        console.log(sugestao_chef);
        console.log(user);
        console.log(categorie);
        console.log(ingredients);
      }
    } catch (error) {
      console.error('Error while fetching receitas', error);
    }
  })();
  /////////////////// Updating Objects /////////////////
  (async () => {
    const query = new Parse.Query(receitas);
    try {
      // here you put the objectId that you want to update
      const object = await query.get('xKue915KBG');
      object.set('title_receita', 'A string');
      object.set('sugestao_chef', 'A string');
      object.set('user', Parse.User.current());
      object.set('categorie', new Parse.Object("categories"));
      object.set('ingredients', new Parse.Object("ingredients"));
      try {
        const response = await object.save();
        // You can use the "get" method to get the value of an attribute
        // Ex: response.get("<ATTRIBUTE_NAME>")
        // Access the Parse Object attributes using the .GET method
        console.log(response.get('title_receita'));
        console.log(response.get('sugestao_chef'));
        console.log(response.get('user'));
        console.log(response.get('categorie'));
        console.log(response.get('ingredients'));
        console.log('receitas updated', response);
      } catch (error) {
        console.error('Error while updating receitas', error);
        }
      } catch (error) {
        console.error('Error while retrieving object receitas', error);
      }
  })();
  /////////////////// Deleting Objects //////////////////////
  (async () => {
    const query = new Parse.Query('receitas');
    try {
      // here you put the objectId that you want to delete
      const object = await query.get('xKue915KBG');
      try {
        const response = await object.destroy();
        console.log('Deleted ParseObject', response);
      } catch (error) {
        console.error('Error while deleting ParseObject', error);
      }
    } catch (error) {
      console.error('Error while retrieving ParseObject', error);
    }
  })();