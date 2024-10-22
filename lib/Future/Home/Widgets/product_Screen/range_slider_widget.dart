// ignore_for_file: avoid_print

import '../../Cubits/rangeSliderCubit/range_slider_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyRangeSlider extends StatefulWidget {
  const MyRangeSlider({super.key});

  @override
  State<MyRangeSlider> createState() => _MyRangeSliderState();
}

class _MyRangeSliderState extends State<MyRangeSlider> {
  late RangeValues values;

  late RangeLabels labels;
  // @override
  // void initState() {
  //   cubit = RangeSliderCubit()
  //     ..getMinAndMax(context.read<GetCatigoriesCubit>().idt!);

  //   min = cubit.mamrsModel!.min!;
  //   max = cubit.mamrsModel!.max!;
  //   values = RangeValues(min, max);
  //   labels = RangeLabels(values.start.toInt().toString() + " SP",
  //       values.end.toInt().toString() + " SP");
  //   super.initState();
  // }

  // @override
  // void dispose() {
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RangeSliderCubit, RangeSliderState>(
      builder: (context, state) {
        print(state);

        if (state is RangeSliderLoadingState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is RangeSliderErrorState) {
          return Center(
            child: Text(state.message),
          );
        }
        RangeSliderCubit cubit = context.read<RangeSliderCubit>();

        double min = cubit.mamrsModel?.min ?? 0;
        double max = cubit.mamrsModel?.max ?? 1;
        values = RangeValues(min, max);
        labels = RangeLabels("${values.start.toInt()} SP",
            "${values.end.toInt()} SP");
        if (max != min) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(cubit.mamrsModel!.min.toString()),
              RangeSlider(
                divisions: 1000,
                labels: labels,
                values: values,
                onChanged: (values) {
                  setState(() {
                    this.values = values;
                  });
                },
                max: max,
                min: min,
              ),
              Text(cubit.mamrsModel!.max.toString()),
            ],
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
