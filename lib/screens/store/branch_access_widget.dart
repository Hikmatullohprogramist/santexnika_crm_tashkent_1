import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:santexnika_crm/screens/login/cubit/login_cubit.dart';
import 'package:santexnika_crm/screens/settings/cubit/branches/branches_cubit.dart';

class BranchAccessEditAndDelete extends StatefulWidget {
  final Widget child;
  const BranchAccessEditAndDelete({super.key, required this.child});

  @override
  State<BranchAccessEditAndDelete> createState() =>
      _BranchAccessEditAndDeleteState();
}

class _BranchAccessEditAndDeleteState extends State<BranchAccessEditAndDelete> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BranchesCubit, BranchesState>(
      builder: (context, state) {
        if (state is BranchesSuccessState) {
          return BlocBuilder<LoginCubit, LoginState>(
            builder: (context, userState) {
              if (userState is LoginSuccess) {
                final isAdmin = userState.data.role == "2";
                print(userState.data.role);
                print("admin ${isAdmin ? " siz" : "emas siz"} ");
                return Visibility(
                  visible: isAdmin,
                  child: widget.child,
                );
              }
              return const SizedBox();
            },
          );
        }
        return const SizedBox();
      },
    );
  }
}
