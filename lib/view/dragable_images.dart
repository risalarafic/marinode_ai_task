import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DragableImages extends StatefulWidget {
  const DragableImages({super.key});

  @override
  State<DragableImages> createState() => _DragableImagesState();
}

class _DragableImagesState extends State<DragableImages> with SingleTickerProviderStateMixin {
  List<String> images=[
    'assets/images/image1.jpg',
    'assets/images/image2.jpg',
    'assets/images/image3.jpg',
    'assets/images/image4.jpg',
    'assets/images/image5.jpg',
    'assets/images/image6.jpg',
    'assets/images/image7.jpg',
    'assets/images/image8.jpg',
    'assets/images/image9.jpg',];

  int? draggingindex;
  @override
  Widget build(BuildContext context) {
    double screenwidth=MediaQuery.of(context).size.width;
    double itemsize=screenwidth/3;
    double hieght=itemsize*3;
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: screenwidth,
            height: hieght,
            child: Stack(
                children:
                List.generate(9, (index){
                  int row = index ~/ 3;
                  int col = index % 3;
                  return AnimatedPositioned(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    left: col * itemsize,
                    top: row * itemsize,
                    width: itemsize,
                    height: itemsize,
                    child: buildDragTarget(index, itemsize),
                  );
                })
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDragTarget(int index, double size) {
    return DragTarget<int>(
      onWillAcceptWithDetails: (details) => details.data != index,
      onAcceptWithDetails: (details) {
        setState(() {
          final fromIndex = details.data;
          final temp = images[fromIndex];
          images[fromIndex] = images[index];
          images[index] = temp;
        });
      },
      builder: (context, candidateData, rejectedData) {
        return buildDraggableItem(index, size);
      },
    );
  }


  Widget buildDraggableItem(int index, double size) {
    return Draggable<int>(
      data: index,
      onDragStarted: () {
        setState((() {
          draggingindex = index;
        }));
      },
      onDraggableCanceled: (_, __) => setState(() {
        draggingindex = null;
      }),
      onDragEnd: (_) => setState(() {
        draggingindex = null;
      }),
      feedback: Material(
        color: Colors.transparent,
        child: Container(
          width: size,
          height: size,
          child: Image.asset(images[index], fit: BoxFit.cover),
        ),
      ),
      childWhenDragging: Container(color: Colors.grey.shade200),
      child: Container(
        margin: EdgeInsets.all(2),
        decoration: BoxDecoration(border: Border.all(color: Colors.black26)),
        child: Image.asset(images[index], fit: BoxFit.cover),
      ),
    );
  }

}
