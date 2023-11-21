const Categories = Parse.Object.extend('categories');
const Ingrediente = Parse.Object.extend('ingredients');
const Medidas = Parse.Object.extend('unidade_medida');
const Receita = Parse.Object.extend('receitas');
const Report = Parse.Object.extend('Reports');

//////////////////////////// CATEGORIA ///////////////////////////////////////////////////////

Parse.Cloud.define('get-categories', async (req) => {
	const queryCategories = new Parse.Query(Categories);

	// condições

	const resultCategories = await queryCategories.find({ useMasterKey: true });

	return resultCategories.map(function (p) {
		p = p.toJSON();
		return {
			categorie: p.categorie,
			pendente: p.pendente,
			objectId: p.objectId
		}
	});
}
);

Parse.Cloud.define('create-categorie', async (req) => {
	const categorie = new Categories();
	categorie.set('categorie', req.params.categorie);
	const saveCategorie = await categorie.save(null, { useMasterKey: true });
	return saveCategorie;
});


Parse.Cloud.define('change-categorie-name', async (req) => {
	const categorie = new Categories();
	categorie.id = req.params.categorieId;
	categorie.set("categorie", req.params.categorie);
	const saveCategorie = await categorie.save(null, { useMasterKey: true });
	return saveCategorie;
});

Parse.Cloud.define('change-categorie-status', async (req) => {
	const categorie = new Categories();
	categorie.id = req.params.categorieId;
	categorie.set("pendente", req.params.pendente);
	const saveCategorie = await categorie.save(null, { useMasterKey: true });
	return saveCategorie;
});

Parse.Cloud.define('delete-categorie', async (req) => {
	const categorie = new Categories();
	categorie.id = req.params.categorieId;
	await categorie.destroy({ useMasterKey: true });
	return "Categoria excluída com sucesso!";
});

//////////////////////////// MEDIDA ///////////////////////////////////////////////////////


Parse.Cloud.define('get-medidas', async (req) => {
	const queryMedidas = new Parse.Query(Medidas);

	// condições

	const resultMedidas = await queryMedidas.find({ useMasterKey: true });

	return resultMedidas.map(function (p) {
		p = p.toJSON();
		return {
			medida: p.medida,
			pendente: p.pendente,
			objectId: p.objectId
		}
	});
}
);

Parse.Cloud.define('create-medidas', async (req) => {
	const medida = new Medidas();
	medida.set('medida', req.params.medida);
	const saveMedida = await medida.save(null, { useMasterKey: true });
	return saveMedida;
});


Parse.Cloud.define('change-medida-name', async (req) => {
	const medida = new Medidas();
	medida.id = req.params.medidaId;
	medida.set("medida", req.params.categorie);
	const saveMedida = await medida.save(null, { useMasterKey: true });
	return saveMedida;
});

Parse.Cloud.define('change-medida-status', async (req) => {
	const medida = new Medidas();
	medida.id = req.params.medidaId;
	medida.set("pendente", req.params.pendente);
	const saveMedida = await medida.save(null, { useMasterKey: true });
	return saveMedida;
});

Parse.Cloud.define('delete-medida', async (req) => {
	const medida = new Medidas();
	medida.id = req.params.medidaId;
	await medida.destroy({ useMasterKey: true });
	return "Medida excluída com sucesso!";
});


/////////////////////// INGREDIENTE ////////////////////////////////////////////////////////////


Parse.Cloud.define('get-ingredientes', async (req) => {
	const queryIngredientes = new Parse.Query(Ingrediente);

	// condições

	const resultIngredientes = await queryIngredientes.find({ useMasterKey: true });

	return resultIngredientes.map(function (p) {
		p = p.toJSON();
		return {
			ingrediente: p.ingrediente,
			pendente: p.pendente,
			objectId: p.objectId
		}
	});
}
);

Parse.Cloud.define('create-ingrediente', async (req) => {
	const ingrediente = new Ingrediente();
	ingrediente.set('ingrediente', req.params.ingrediente);
	const saveIngrediente = await ingrediente.save(null, { useMasterKey: true });
	return saveIngrediente;
});


Parse.Cloud.define('change-ingrediente-name', async (req) => {
	const ingrediente = new Ingrediente();
	ingrediente.id = req.params.ingredienteId;
	ingrediente.set("ingrediente", req.params.ingrediente);
	const saveIngrediente = await ingrediente.save(null, { useMasterKey: true });
	return saveIngrediente;
});

Parse.Cloud.define('change-ingrediente-status', async (req) => {
	const ingrediente = new Ingrediente();
	ingrediente.id = req.params.ingredienteId;
	ingrediente.set("pendente", req.params.pendente);
	const saveIngrediente = await ingrediente.save(null, { useMasterKey: true });
	return saveIngrediente;
});

Parse.Cloud.define('delete-ingrediente', async (req) => {
	const ingrediente = new Medidas();
	ingrediente.id = req.params.ingredienteId;
	await ingrediente.destroy({ useMasterKey: true });
	return "Medida excluída com sucesso!";
});
///////////////////////////// RECEITA ///////////////////////////////////////////////////

Parse.Cloud.define('create-receita', async (req) => {
	if (req.params.userId == null) throw "Usuário inválido";
	if (req.params.categorieId == null) throw "Categoria inválido";
	const receita = new Receita();
	const { photo, ...restParams } = req.params;
	const photoFile = new Parse.File('photo.jpg', { base64: photo }); // Se desejar, substitua 'photo.jpg' pelo nome desejado do arquivo.
	await photoFile.save({ useMasterKey: true });

	const user = new Parse.User();
	user.id = req.params.userId;

	const categorie = new Categories();
	categorie.id = req.params.categorieId;

	receita.set('title_receita', req.params.title_receita);
	receita.set('sugestao_chef', req.params.sugestao_chef);
	receita.set('modo_preparo', req.params.modo_preparo);
	receita.set('user', user);
	receita.set('ingredientes', req.params.ingredientes);
	receita.set('categorie', categorie);
	receita.set('photo', photoFile);

	const saveReceita = await receita.save(null, { useMasterKey: true });
	return saveReceita;
});

Parse.Cloud.define('update-receita', async (req) => {
	const { photo, userId, categorieId, ...restParams } = req.params;
  
	const query = new Parse.Query(Receita);
	const receita = await query.get(restParams.receitaId, { useMasterKey: true });
  
	if (photo) {
	  const photoFile = new Parse.File('photo.jpg', { base64: photo });
	  await photoFile.save({ useMasterKey: true });
	  receita.set('photo', photoFile);
	}
  
	if (userId) {
	  const user = new Parse.User();
	  user.id = userId;
	  receita.set('user', user);
	}
  
	if (categorieId) {
	  const categorie = new Categories();
	  categorie.id = categorieId;
	  receita.set('categorie', categorie);
	}
  
	Object.keys(restParams).forEach((param) => {
	  if (restParams[param]) {
		receita.set(param, restParams[param]);
	  }
	});
  
	const saveReceita = await receita.save(null, { useMasterKey: true });
	return saveReceita;
  });

Parse.Cloud.define('get-receitas', async (req) => {
	const queryReceitas = new Parse.Query(Receita);

	// Inclua o relacionamento 'user'.
	queryReceitas.include('user');

	const resultReceitas = await queryReceitas.find({ useMasterKey: true });

	return resultReceitas.map(function (p) {
		p = p.toJSON();
		return {
			title_receita: p.title_receita,
			sugestao_chef: p.sugestao_chef,
			modo_preparo: p.modo_preparo,
			ingredientes: p.ingredientes,
			fullname: p.user.fullname,
			categorie: p.categorie,
			photo: p.photo ? p.photo.url : null,
			objectId: p.objectId
		}
	});
});

Parse.Cloud.define('delete-receita', async (req) => {
	const receita = new Receita();
	receita.id = req.params.receitaId;
	await receita.destroy({ useMasterKey: true });
	return "Receita excluída com sucesso!";
});

//////////////////////////// USER ///////////////////////////////////////////////////////

Parse.Cloud.define('signup', async (req) => {
	if (req.params.fullname == null) throw 'INVALID_FULLNAME';
	if (req.params.phone == null) throw 'INVALID_PHONE';

	const user = new Parse.User();

	user.set('username', req.params.email);
	user.set('email', req.params.email);
	user.set('password', req.params.password);
	user.set('fullname', req.params.fullname);
	user.set('phone', req.params.phone);
	user.set('type', req.params.type);

	const resultUser = await user.signUp(null, { userMasterKey: true });
	const userJson = resultUser.toJSON();
	return formatUser(userJson);

});

Parse.Cloud.define('login', async (req) => {
	try {
		const user = await Parse.User.logIn(req.params.email, req.params.password);
		const userJson = user.toJSON();
		return formatUser(userJson);
	} catch (e) {
		throw 'INVALID_CREDENTIALS';
	}
});

Parse.Cloud.define('get-current-user', async (req) => {
	return req.user;
});

Parse.Cloud.define('add-to-favorites', async (req) => {
	// verifique se o usuário está logado
	const userId = req.params.userId;
	if (!userId) {
		throw 'User not logged in';
	}

	const receitaId = req.params.receitaId;
	if (!receitaId) {
		throw 'No receitaId provided';
	}

	// Busque o usuário
	const query = new Parse.Query(Parse.User);
	query.equalTo('objectId', userId);
	const user = await query.first({ useMasterKey: true });
	if (!user) {
		throw 'User not found';
	}

	// Adicione a receita aos favoritos
	let favorites = user.get('favoritos');
	if (!favorites) {
		favorites = [];
	}

	if (!favorites.includes(receitaId)) {
		favorites.push(receitaId);
		user.set('favoritos', favorites);
		await user.save(null, { useMasterKey: true });
	}

	return 'Receita added to favorites';
});

Parse.Cloud.define('remove-from-favorites', async (req) => {
	// verifique se o usuário está logado
	const userId = req.params.userId;
	if (!userId) {
		throw 'User not logged in';
	}

	const receitaId = req.params.receitaId;
	if (!receitaId) {
		throw 'No receitaId provided';
	}

	// Busque o usuário
	const query = new Parse.Query(Parse.User);
	query.equalTo('objectId', userId);
	const user = await query.first({ useMasterKey: true });
	if (!user) {
		throw 'User not found';
	}

	let favorites = user.get('favoritos');
	if (favorites && favorites.includes(receitaId)) {
		favorites = favorites.filter(id => id !== receitaId);
		user.set('favoritos', favorites);
		await user.save(null, { useMasterKey: true });
	}

	return 'Receita removed from favorites';
});


Parse.Cloud.define('get-favorite-receitas', async (req) => {
	// verifique se o usuário está logado
	const userId = req.params.userId;
	if (!userId) {
		throw 'User not logged in';
	}

	const receitaId = req.params.receitaId;
	if (!receitaId) {
		throw 'No receitaId provided';
	}

	// Busque o usuário
	const query = new Parse.Query(Parse.User);
	query.equalTo('objectId', userId);
	const user = await query.first({ useMasterKey: true });
	if (!user) {
		throw 'User not found';
	}

	const favorites = user.get('favoritos');
	const newQuery = new Parse.Query(Receita);
	query.containedIn('objectId', favorites);
	const receitas = await newQuery.find({ useMasterKey: true });
	// Agora, 'receitas' contém as receitas favoritas do usuário.

	return receitas.map(receita => receita.toJSON());
});

Parse.Cloud.define('get-user-receitas', async (req) => {
	const userId = req.params.userId;

	// Verifique se UserId foi fornecido
	if (!userId) throw 'User not provided';

	// Crie um objeto de usuário com o id fornecido
	const user = new Parse.User();
	user.id = userId;

	// Crie a query que busca as receitas criadas pelo usuário
	const query = new Parse.Query(Receita);
	query.equalTo('user', user); // Aqui presumo que você tenha definido o criador da receita no campo 'user' do objeto Receita

	const resultReceitas = await query.find({ useMasterKey: true });

	return resultReceitas.map(function (p) {
		p = p.toJSON();
		return {
			title_receita: p.title_receita,
			sugestao_chef: p.sugestao_chef,
			modo_preparo: p.modo_preparo,
			ingredientes: p.ingredientes,
			fullname: p.user.fullname,
			categorie: p.categorie,
			photo: p.photo ? p.photo.url : p.photo,
			objectId: p.objectId
		};
	});
});

function formatUser(userJson) {
	return {
		id: userJson.objectId,
		fullname: userJson.fullname,
		email: userJson.email,
		phone: userJson.phone,
		type: userJson.type,
		sessionToken: userJson.sessionToken,
		favoritos: userJson.favoritos,
		userId: userJson.objectId
	}
}

////////////////////// REPORTS /////////////////////////






Parse.Cloud.define('get-reports', async (req) => {
	const queryReports = new Parse.Query('Reports'); // Certifique-se de que 'Report' é o nome da classe correta

	const resultReports = await queryReports.find({ useMasterKey: true });


	return resultReports.map(function (p) {
		p = p.toJSON();



		return {
			report: p.report,
			receitaId: p.receitaId,
			pendente: p.pendente,
			user: p.user,
			objectId: p.objectId,
			createdAt: p.createdAt
		}
	});
});

Parse.Cloud.define('create-report', async (req) => {
	const report = new Report();


	const userQuery = new Parse.Query(Parse.User);

	report.set('report', req.params.report);
	report.set('receitaId', req.params.receitaId);
	report.set('user', req.params.user);

	const saveReport = await report.save(null, { useMasterKey: true });
	return saveReport;
});


Parse.Cloud.define('delete-report', async (req) => {
	const report = new Report();
	report.id = req.params.reportId;
	await report.destroy({ useMasterKey: true });
	return "Denúncia excluída com sucesso!";
});
