class Instructions {
  final List<dynamic> instructions;

  Instructions(this.instructions);

  Instructions.example()
      : instructions = [
          'Get to high ground, minimum elevation: 200 ft.',
        ];

  factory Instructions.fromJson(Map<String, dynamic> json) {
    return Instructions(json['instructions']);
  }

  Map<String, dynamic> toJson() => {'instructions': instructions};
}
