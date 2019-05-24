import 'package:scoped_model/scoped_model.dart';
import 'package:jars/scoped-models/user.dart';
import 'package:jars/scoped-models/jar.dart';

class MainModel extends Model with UserModel, JarModel {}
