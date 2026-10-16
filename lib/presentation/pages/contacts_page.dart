import 'package:chatdcg_demo/presentation/cubit/authen_cubit.dart';
import 'package:chatdcg_demo/presentation/cubit/authen_state.dart';
import 'package:chatdcg_demo/presentation/pages/chat_page.dart';
import 'package:chatdcg_demo/presentation/widget/list_user_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<AuthenCubit>().getUserStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0x1C1C1E),
      appBar: AppBar(
        backgroundColor: const Color(0x1C1C1E),
        title: Text(
          "Contacts",
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        leadingWidth: 72,

        actions: [
          IconButton(
            onPressed: () {},
            icon: SvgPicture.asset(
              "assets/add.svg",
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
              width: 20.w,
              height: 20.h,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<AuthenCubit, AuthenState>(
          buildWhen: (previous, current) =>
              previous.userStatus != current.userStatus,
          builder: (context, state) {
            final users = state.userStatus?.users ?? [];
            return ListView.separated(
              itemCount: users.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatPage(
                          id: users[index].userId ?? 0,
                          isOnline: users[index].isOnline ?? false,
                          userName: users[index].displayName ?? "",
                        ),
                      ),
                    );
                  },
                  child: ListUserWidget(
                    userName: users[index].displayName ?? "",
                    status: users[index].isOnline ?? false,
                  ),
                );
              },
              separatorBuilder: (context, index) => Divider(
                // Avatar width + gap in ListUserWidget, so the line starts at the name
                indent: 40.h + 10.w,
                height: 1,
                thickness: 0.2,
                color: Colors.grey.shade800,
              ),
            );
          },
        ),
      ),
    );
  }
}
