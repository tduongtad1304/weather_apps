part of 'background_images_cubit.dart';

class BackgroundImageState extends Equatable {
  final bool isHot;

  const BackgroundImageState({
    required this.isHot,
  });

  @override
  List<Object> get props => [isHot];

  BackgroundImageState copyWith({
    bool? isHot,
  }) {
    return BackgroundImageState(
      isHot: isHot ?? this.isHot,
    );
  }

  factory BackgroundImageState.initial() {
    return const BackgroundImageState(
      isHot: false,
    );
  }

  @override
  String toString() => 'BackgroundImageState(isHot: $isHot)';
}
