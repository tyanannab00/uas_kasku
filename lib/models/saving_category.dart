import 'package:flutter/material.dart';

class SavingCategory {
  final String id;
  final String name;
  int balance;
  int target;               
  final Color color;

  SavingCategory({
    required this.id,
    required this.name,
    this.balance = 0,
    this.target = 0,        
    required this.color,
  });
 
  factory SavingCategory.fromMap(Map<String, dynamic> map) {
    return SavingCategory(
      id: map['id'],
      name: map['name'],
      balance: map['balance'] ?? 0,   
      target: map['target'] ?? 0,     
      color: Color(map['color']),     
    );
  }
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'balance': balance,
      'target': target,
      'color': color.value,            
    };
  }
}
