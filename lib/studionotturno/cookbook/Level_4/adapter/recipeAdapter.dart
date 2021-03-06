
import 'dart:convert';

import 'package:ricettario/studionotturno/cookbook/Level_3/recipe/recipe.dart';
import 'target.dart';
import 'executionTimeAdapter.dart';
import 'ingredientAdapter.dart';

///Implementa Target e è quindi la classe Adattatore di una Ricetta.
///Adatta i dati tra client e server, cioè tra i dati in locale e quilli in cloud.
///E' una classe del desing pattern Adapter
class RecipeAdapter extends Target{

  Recipe recipe;

  RecipeAdapter(){
    this.recipe=new Recipe("name");
  }

  RecipeAdapter setRecipe(Recipe recipe){
    this.recipe=recipe;
    return this;
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "name": this.recipe.name,
      "description": this.recipe.description,
      "difficult": this.recipe.difficult,
      "executionTime": this.recipe.executionTime.getMinutes(),
      "ingredients":this.recipe.ingredients.map((model)=>IngredientAdapter().setIngredient(model).toJson()).toList()
    };
  }

  @override
  Recipe toObject(Map<dynamic, dynamic> data) {
    this.recipe.name = data['name'];
    this.recipe.description = data['description'];
    this.recipe.difficult = data['difficult'];
    this.recipe.executionTime=ExecutionTimeAdapter().toObject(data['executionTime']);
    Iterable l= data['ingredients'];
    this.recipe.ingredients = l.map((model)=>IngredientAdapter().toObject(model)).toList();
    return this.recipe;
  }

  Recipe toObjectByString(String ele) {
    Map<dynamic,dynamic> s=jsonDecode(ele);
    return toObject(s);

  }

}