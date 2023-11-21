////////////////////// Creating Objects ///////////////////////
(async () => {
    const myNewObject = new Parse.Object('ingredients');
    myNewObject.set('ingrediente', 'A string');
    try {
      const result = await myNewObject.save();
      // Access the Parse Object attributes using the .GET method
      console.log('ingredients created', result);
    } catch (error) {
      console.error('Error while creating ingredients: ', error);
    }
  })();
  
  ////////////////////// Reading Objects ///////////////////////////////////
  
  (async () => {
    const ingredients = Parse.Object.extend('ingredients');
    const query = new Parse.Query(ingredients);
    // You can also query by using a parameter of an object
    // query.equalTo('objectId', 'xKue915KBG');
    try {
      const results = await query.find();
      for (const object of results) {
        // Access the Parse Object attributes using the .GET method
        const ingrediente = object.get('ingrediente')
        console.log(ingrediente);
      }
    } catch (error) {
      console.error('Error while fetching ingredients', error);
    }
  })();
  
  //////////////////////// Updating Objects /////////////////////////////////
  
  (async () => {
    const query = new Parse.Query(ingredients);
    try {
      // here you put the objectId that you want to update
      const object = await query.get('xKue915KBG');
      object.set('ingrediente', 'A string');
      try {
        const response = await object.save();
        // You can use the "get" method to get the value of an attribute
        // Ex: response.get("<ATTRIBUTE_NAME>")
        // Access the Parse Object attributes using the .GET method
        console.log(response.get('ingrediente'));
        console.log('ingredients updated', response);
      } catch (error) {
        console.error('Error while updating ingredients', error);
        }
      } catch (error) {
        console.error('Error while retrieving object ingredients', error);
      }
  })();
  
  ////////////////////// Deleting Objects //////////////////////////////
  
  (async () => {
    const query = new Parse.Query('ingredients');
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