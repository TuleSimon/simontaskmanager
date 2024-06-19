import 'dart:io';

String readJson(JsonsPaths path)=> File('test/jsons/${path.filePath}').readAsStringSync();

abstract class JsonsPaths{
 final String filePath;

  JsonsPaths(this.filePath);

}

class TodoPaths extends JsonsPaths{
  TodoPaths():super("todo.json");
}
class TodosPaths extends JsonsPaths{
  TodosPaths():super("todos.json");
}
class TokenPath extends JsonsPaths{
  TokenPath():super("token.json");
}
class UserPath extends JsonsPaths{
  UserPath():super("user.json");
}