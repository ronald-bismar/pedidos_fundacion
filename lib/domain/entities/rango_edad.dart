class AgeRange {
  final int minAge;
  final int maxAge;

  AgeRange(this.minAge, this.maxAge) {
    if (minAge < 0) throw ArgumentError('La edad mínima no puede ser negativa');
    if (maxAge < minAge)
      throw ArgumentError('La edad máxima no puede ser menor que la mínima');
  }
  
  @override
  String toString() => '$minAge a $maxAge años';
}
