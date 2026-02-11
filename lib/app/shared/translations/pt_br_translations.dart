/// Mapeamento de traduções de português-BR para informações dos personagens
class PtBrTranslations {
  /// Mapeia raças em inglês para português-BR
  static const Map<String, String> races = {
    'Saiyan': 'Saiyajin',
    'Human': 'Humano',
    'Namekian': 'Namekiano',
    'Frieza Race': 'Raça de Freeza',
    'Android': 'Androide',
    'Unknown': 'Desconhecida',
    'God': 'Deus',
    'Angel': 'Anjo',
    'Demon': 'Demônio',
  };

  /// Mapeia gêneros em inglês para português-BR
  static const Map<String, String> genders = {
    'Male': 'Masculino',
    'Female': 'Feminino',
    'Unknown': 'Desconhecido',
  };

  /// Mapeia afiliações em inglês para português-BR
  static const Map<String, String> affiliations = {
    'Z Fighter': 'Guerreiro Z',
    'Red Ribbon Army': 'Exército da Fita Vermelha',
    'Frieza Force': 'Força de Freeza',
    'Saiyan': 'Saiyajin',
    'Evil': 'Vilão',
    'God of Destruction': 'Deus da Destruição',
    'Neutral': 'Neutro',
    'Unknown': 'Desconhecida',
    'None': 'Nenhuma',
  };

  /// Traduz texto usando o mapa fornecido
  static String translate(String text, Map<String, String> translationMap) {
    return translationMap[text] ?? text;
  }

  /// Traduz raça
  static String translateRace(String race) {
    return translate(race, races);
  }

  /// Traduz gênero
  static String translateGender(String gender) {
    return translate(gender, genders);
  }

  /// Traduz afiliação
  static String translateAffiliation(String affiliation) {
    return translate(affiliation, affiliations);
  }

  /// Traduz números para português-BR
  /// Exemplo: "3 Billion" -> "3 Bilhão"
  static String translateNumberPtBr(String numberStr) {
    final translations = {
      'Billion': 'Bilhão',
      'Trillion': 'Trilhão',
      'Quadrillion': 'Quatrilhão',
      'Quintillion': 'Quintilhão',
      'Sextillion': 'Sextilhão',
      'Septillion': 'Septilhão',
      'Octillion': 'Octilhão',
      'Nonillion': 'Nonilhão',
      'Decillion': 'Decilhão',
      'Million': 'Milhão',
      'Thousand': 'Mil',
    };

    String result = numberStr;
    
    // Substitui os sufixos em inglês pelos equivalentes em português
    translations.forEach((english, portuguese) {
      result = result.replaceAll(english, portuguese);
    });

    return result;
  }

}
