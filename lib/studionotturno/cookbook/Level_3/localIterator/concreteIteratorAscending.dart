
import 'package:ricettario/studionotturno/cookbook/Level_3/recipe/recipe.dart';
import 'irecipesIterator.dart';

///Un concrete iterator per gestire l'attraversamento di una collezione riceracre
///elementi al di sotto di un determinata difficoltà

///Fa parte del patter Iterator ( concrete iterator )
class ConcreteIteratorAscending implements IRecipesIterator{

  Set<Recipe> set;
  int currentPosition=0;

  ConcreteIteratorAscending(Set<Recipe> set){
    this.set=reorderAscending(set);
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

  Set<Recipe> reorderAscending(Set<Recipe> set){
    List<Recipe> l=set.toList();
    l.sort((a,b)=>a.getName().compareTo(b.getName()));
    return l.toSet();
  }

}