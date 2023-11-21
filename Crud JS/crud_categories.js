////////////////////// Creating Objects ///////////////////////
(async () => {
    const myNewObject = new Parse.Object('categories');
    myNewObject.set('categorie', 'A string');
    try {
      const result = await myNewObject.save();
      // Access the Parse Object attributes using the .GET method
      console.log('categories created', result);
    } catch (error) {
      console.error('Error while creating categories: ', error);
    }
  })();

//////////////////////// Reading Objects /////////////////////////////

(async () => {
    const categories = Parse.Object.extend('categories');
    const query = new Parse.Query(categories);
    // You can also query by using a parameter of an object
    // query.equalTo('objectId', 'xKue915KBG');
    try {
      const results = await query.find();
      for (const object of results) {
        // Access the Parse Object attributes using the .GET method
        const categorie = object.get('categorie')
        console.log(categorie);
      }
    } catch (error) {
      console.error('Error while fetching categories', error);
    }
  })();

  ////////////////////// Updating Objects //////////////////////////////////

  (async () => {
    const query = new Parse.Query(categories);
    try {
      // here you put the objectId that you want to update
      const object = await query.get('xKue915KBG');
      object.set('categorie', 'A string');
      try {
        const response = await object.save();
        // You can use the "get" method to get the value of an attribute
        // Ex: response.get("<ATTRIBUTE_NAME>")
        // Access the Parse Object attributes using the .GET method
        console.log(response.get('categorie'));
        console.log('categories updated', response);
      } catch (error) {
        console.error('Error while updating categories', error);
        }
      } catch (error) {
        console.error('Error while retrieving object categories', error);
      }
  })();

  //////////////////////// Deleting Objects /////////////////////////////////

  (async () => {
    const query = new Parse.Query('categories');
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