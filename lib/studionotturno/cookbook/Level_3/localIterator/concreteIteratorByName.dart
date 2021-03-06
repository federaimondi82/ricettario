
import 'package:ricettario/studionotturno/cookbook/Level_3/recipe/recipe.dart';
import 'irecipesIterator.dart';

///Un concrete iterator per gestire l'attraversamento di una collezione e selezionare
/// quelle che hanno un nome simile a quello richiesto.
///Fa parte del patter Iterator ( concrete iterator )
///Responsabilità di cercare in una collezione di ricette tutte le ricette con un certo nome
class ConcreteIteratorByName implements IRecipesIterator{

  Set<Recipe> set;
  int currentPosition=0;

  ConcreteIteratorByName(Set<Recipe> set,String name){
    this.set=searchByRecipeName(set,name);
  }

  @override
  bool hasNext() {
    return this.currentPosition<set.length;
  }

  @override
  Recipe next() {
    if(hasNext()) return this.set.elementAt(this.currentPosition++);
    return null;
  }

  @override
  void reset() {
    this.currentPosition=0;
  }

  Set<Recipe> searchByRecipeName(Set<Recipe> set,String name){
    if(name=="" || name==null) throw new Exception("nome non valido");
    return set.where((el)=>el.getName().contains(name)).toSet();
  }



}