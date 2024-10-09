import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:jangboo_flutter/app/data/const/image_path.dart';
import 'package:jangboo_flutter/app/ui/web/introduce/widget/padding_column_widget.dart';
import 'package:jangboo_flutter/app/ui/widget/border_container_widget.dart';

class ImageTitleWidget extends StatelessWidget {
  const ImageTitleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return PaddingColumn(
      children: [
        Gap(100),
        AspectRatio(
          aspectRatio: 1920 / 1085,
          child: BorderContainerWidget(
              color: Colors.black,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      showMainImage,
                      fit: BoxFit.fill,
                    )),
              )),
        ),
        Gap(50),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '빠르게 찾고',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '편리하게 결제',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '사장님을 위한 장부 서비스',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }
}
