import 'package:flutter/material.dart';
import 'package:pamsimas/helpers/base_color.dart';

class BuildCategory extends StatelessWidget {
  final String? category;

  const BuildCategory({Key? key, this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildBody(category!);
  }

  Widget _buildBody(String category){
    Color? _color;
    switch(category){
      case 'R':
        _color = BaseColor.green;
        break;
      case 'S':
        _color = BaseColor.orange;
        break;
      case 'P':
        _color = BaseColor.lightBlue;
        break;
      case 'B':
        _color = BaseColor.red;
        break;
      default:
        _color = BaseColor.grey;
        break;
    }
    return Container(
      child: Text(category,style: TextStyle(fontSize: 12,color: BaseColor.white),),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: _color,
        shape: BoxShape.circle,
      ),
    );
  }
}
