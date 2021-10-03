import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hng/constants/app_strings.dart';
import 'package:stacked/stacked.dart';

import '../../shared/colors.dart';
import 'view_profile_viewmodel.dart';
import 'widgets/profile_action.dart';
import 'widgets/profile_list.dart';

class ViewProfile extends StatelessWidget {
  const ViewProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ViewProfileViewModel>.reactive(
      viewModelBuilder: () => ViewProfileViewModel(),
      builder: (context, model, child) => model.isBusy ? 
      const Center(child: CircularProgressIndicator()) : 
      DraggableScrollableSheet(
            initialChildSize: 0.9,
            minChildSize: 0.8,
            maxChildSize: 1.0,
            builder:
                (BuildContext context, ScrollController scrollController) =>
                    SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              controller: scrollController,
              child: Visibility(
                visible: !model.isBusy,
                replacement: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(GettingYourData),
                      CircularProgressIndicator(
                        color: AppColors.zuriPrimaryColor,
                      ),
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.3,
                          width: MediaQuery.of(context).size.width,
                          child: Stack(
                            fit: StackFit.expand,
                            children: const [
                              Image(
                                fit: BoxFit.cover,
                                image: AssetImage(UserAvatar),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          bottom: 20.0,
                          left: 12.0,
                          child: Row(
                            children: [
                              Text(
                                model.userData.firstName.toString(),
                                //TODO change this to AppTextStyle
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 18.0,
                                ),
                              ),
                              Container(
                                //Icon wrapped in container with margin, so long names with stack over/below it
                                margin: const EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.circle,
                                  size: 12.0,
                                  // color: isActive!
                                  color: model.isActive == true
                                      ? AppColors.zuriPrimaryColor
                                      : Colors.transparent,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          top: 16.0, left: 20.0, right: 16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ProfileAction(
                                title: const Text(MessageText),
                                onTap: () {},
                              ),
                              ProfileAction(
                                title: const Text(EditProfile),
                                onTap: () {
                                  // model.editProfile;
                                },
                              ),
                              ProfileAction(
                                title: const Icon(Icons.more_horiz),
                                onTap: () {},
                              ),
                            ],
                          ),
                          const Divider(),
                          ProfileList(
                              title: Track,
                              description: model.userData.status.toString()),
                          const Divider(),
                          ProfileList(
                              title: DisplayName,
                              description:
                                  model.userData.displayName.toString()),
                          const Divider(),
                          ProfileList(
                              title: StatusText, description: model.status),
                          const Divider(),
                          ProfileList(
                              title: Phone,
                              description: model.userData.phoneNum.toString()),
                          const Divider(),
                          ProfileList(
                              title: EmailAddress,
                              description: model.currentUserEmail)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
    );
  }
}
