import 'package:scoped_model/scoped_model.dart';
import 'package:fude/scoped-models/user.dart';
import 'package:fude/scoped-models/recipe.dart';
import 'package:fude/scoped-models/jar.dart';

class MainModel extends Model with UserModel, RecipeModel, JarModel {}
