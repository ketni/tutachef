////////////////////// Creating Objects ///////////////////////
(async () => {
    const myNewObject = new Parse.Object('unidade_medida');
    myNewObject.set('medida', 'A string');
    try {
      const result = await myNewObject.save();
      // Access the Parse Object attributes using the .GET method
      console.log('unidade_medida created', result);
    } catch (error) {
      console.error('Error while creating unidade_medida: ', error);
    }
  })();
  //////////////// Reading Objects /////////////////
  (async () => {
    const unidade_medida = Parse.Object.extend('unidade_medida');
    const query = new Parse.Query(unidade_medida);
    // You can also query by using a parameter of an object
    // query.equalTo('objectId', 'xKue915KBG');
    try {
      const results = await query.find();
      for (const object of results) {
        // Access the Parse Object attributes using the .GET method
        const medida = object.get('medida')
        console.log(medida);
      }
    } catch (error) {
      console.error('Error while fetching unidade_medida', error);
    }
  })();
  //////////////// Updating Objects //////////////////
  (async () => {
    const query = new Parse.Query(unidade_medida);
    try {
      // here you put the objectId that you want to update
      const object = await query.get('xKue915KBG');
      object.set('medida', 'A string');
      try {
        const response = await object.save();
        // You can use the "get" method to get the value of an attribute
        // Ex: response.get("<ATTRIBUTE_NAME>")
        // Access the Parse Object attributes using the .GET method
        console.log(response.get('medida'));
        console.log('unidade_medida updated', response);
      } catch (error) {
        console.error('Error while updating unidade_medida', error);
        }
      } catch (error) {
        console.error('Error while retrieving object unidade_medida', error);
      }
  })();
  ////////////////// Deleting Objects /////////////////////
  (async () => {
    const query = new Parse.Query('unidade_medida');
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