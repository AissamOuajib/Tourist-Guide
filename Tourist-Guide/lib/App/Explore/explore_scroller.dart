import 'package:flutter/material.dart';

List<CardItemViewModel> exploreCards = [
  CardItemViewModel(
    imageAssetPath: 'assets/chefchaouneCouverture.jpg',
    title: 'The blue city',
    location: 'Chefchoune',
    rating: 4.5
  ),
  CardItemViewModel(
    imageAssetPath: 'assets/saharaCouverture.png',
    title: 'Sahara',
    location: 'Bizakarn, Dakhla',
    rating: 5
  ),
  CardItemViewModel(
    imageAssetPath: 'assets/marrakechCouverture.jpg',
    title: 'Jamee Lefna',
    location: 'Marrakech',
    rating: 3.5
  ),
  CardItemViewModel(
    imageAssetPath: 'assets/agadirCouverture.jpg',
    title: 'Agadir Oufella',
    location: 'Agadir',
    rating: 4
  ),
  CardItemViewModel(
    imageAssetPath: 'assets/saharaCouverture.png',
    title: 'Sahara',
    location: 'Bizakarn, Dakhla',
    rating: 5
  ),
];

class ExploreScroller extends StatelessWidget {

  final double parentSize;
  final int index;
  // final  document;


  ExploreScroller({this.parentSize, this.index});

  Widget _buildItem({double parentSize, CardItemViewModel viewModel, int index, BuildContext context}) {
    double edgeSize = 8.0;
    double itemSize = parentSize - edgeSize * 2.0;
    return InkWell(
      onTap: (){
        print('you tapped $index');
          // Navigator.of(context).push(
          //   MaterialPageRoute(
          //     builder: (context) => new DestinationPage(
          //       viewModel: exploreCards[index],
          //     ),
          //   )
          // );
      },
      child: Container(
        padding: EdgeInsets.all(edgeSize),
        child: SizedBox(
          width: itemSize,
          height: itemSize,
          child: Card(
            elevation: 7,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(viewModel.imageAssetPath),
                  fit: BoxFit.cover
                ),
                borderRadius: BorderRadius.circular(5)
              ),
              alignment: AlignmentDirectional.center,
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 3.0, bottom: 3),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(viewModel.title, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      Text(viewModel.location, style: TextStyle(color: Colors.white, fontSize: 16)),
                      Row(
                        children: <Widget>[
                          Icon(Icons.star, color: Colors.orangeAccent,),
                          Text('${viewModel.rating}', style: TextStyle(color: Colors.white, fontSize: 16)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildItem(
      parentSize: parentSize,
      viewModel: exploreCards[index],
      index: index,
      context: context,
    );
  }
}


class CardItemViewModel{
  String imageAssetPath;
  String title;
  String location;
  double rating;

  CardItemViewModel({
    this.imageAssetPath,
    this.title,
    this.location,
    this.rating
  });
}