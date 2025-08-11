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

  static ({bool isValid, String mensaje}) validateAgeInRange(
    int age,
    AgeRange ageRange,
  ) {
    // Calcular la diferencia mínima al rango
    final differenceFromMin = (age - ageRange.minAge).abs();
    final differenceFromMax = (age - ageRange.maxAge).abs();
    final minDifference = differenceFromMin < differenceFromMax
        ? differenceFromMin
        : differenceFromMax;

    // Solo mostrar advertencia si la diferencia es considerable (más de 2 años)
    if (minDifference > 2) {
      String mensaje;

      if (age < ageRange.minAge) {
        if (ageRange.minAge == ageRange.maxAge) {
          mensaje =
              'La edad $age años es muy menor al requerido. Este grupo es específicamente para ${ageRange.minAge} años.';
        } else {
          mensaje =
              'La edad $age años es muy menor al rango permitido (${ageRange.toString()}). La diferencia es considerable.';
        }
      } else {
        if (ageRange.minAge == ageRange.maxAge) {
          mensaje =
              'La edad $age años es muy mayor al requerido. Este grupo es específicamente para ${ageRange.maxAge} años.';
        } else {
          mensaje =
              'La edad $age años es muy mayor al rango permitido (${ageRange.toString()}). La diferencia es considerable.';
        }
      }

      return (
        isValid: false,
        mensaje:
            '$mensaje Considera revisar si seleccionaste el grupo correcto.',
      );
    }

    // Si la diferencia es pequeña (1-2 años), permitir pero sin mensaje
    return (isValid: true, mensaje: '');
  }
}
