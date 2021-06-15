import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:pandemia/data/database/FuzzyCalculations.dart';

void main() {

  var fuzzyCalculations = new FuzzyCalculations();
  fuzzyCalculations.addMyRules();
  test('a1 must be less than or equal for all possible inputs', () {
    ///order of entries : (int _popularity , int _placevisited ,int _incidence,int _timeOfvisit)
    int a = fuzzyCalculations.resolve(0,0,0,0);
    int b = fuzzyCalculations.resolve(new Random().nextInt(100),new Random().nextInt(100),new Random().nextInt(100),new Random().nextInt(100));
    expect(a<=b,true);
  });
  test('a must be greater than or equal for all possible inputs', () {
    ///order of entries : (int _popularity , int _placevisited ,int _incidence,int _timeOfvisit)
    int a = fuzzyCalculations.resolve(100,100,100,100);
    int b = fuzzyCalculations.resolve(new Random().nextInt(100),new Random().nextInt(100),new Random().nextInt(100),new Random().nextInt(100));
    expect(a>=b,true);
  });
  test('a must be greater than b', () {
    ///order of entries : (int _popularity , int _placevisited ,int _incidence,int _timeOfvisit)
    int a = fuzzyCalculations.resolve(90,70,80,30);
    int b = fuzzyCalculations.resolve(90,50,80,30);
    expect(a>b,true);
  });
  test('a must be greater than b', () {
    ///order of entries : (int _popularity , int _placevisited ,int _incidence,int _timeOfvisit)
    int a = fuzzyCalculations.resolve(90,70,80,30);
    int b = fuzzyCalculations.resolve(40,50,80,10);
    expect(a>b,true);
  });
  test('a must be greater than b', () {
    ///order of entries : (int _popularity , int _placevisited ,int _incidence,int _timeOfvisit)
    int a = fuzzyCalculations.resolve(60,70,80,30);
    int b = fuzzyCalculations.resolve(50,10,50,30);
    expect(a>b,true);
  });

  test('a must be greater than b', () {
    ///order of entries : (int _popularity , int _placevisited ,int _incidence,int _timeOfvisit)
    int a = fuzzyCalculations.resolve(90,70,80,30);
    int b = fuzzyCalculations.resolve(75,70,80,30);
    expect(a>b,true);
  });
  test('a must be greater than b', () {
    ///order of entries : (int _popularity , int _placevisited ,int _incidence,int _timeOfvisit)
    int a = fuzzyCalculations.resolve(90,70,80,30);
    int b = fuzzyCalculations.resolve(90,70,60,30);
    expect(a>b,true);
  });
  test('a must be greater than b', () {
    ///order of entries : (int _popularity , int _placevisited ,int _incidence,int _timeOfvisit)
    int a = fuzzyCalculations.resolve(90,70,80,50);
    int b = fuzzyCalculations.resolve(90,70,80,30);
    expect(a>b,true);
  });
  test('a must be greater than b', () {
    ///order of entries : (int _popularity , int _placevisited ,int _incidence,int _timeOfvisit)
    int a = fuzzyCalculations.resolve(10,50,63,77);
    int b = fuzzyCalculations.resolve(10,50,60,77);
    expect(a>b,true);
  });
  test('a must be greater than b', () {
    ///order of entries : (int _popularity , int _placevisited ,int _incidence,int _timeOfvisit)
    int a = fuzzyCalculations.resolve(25,50,63,77);
    int b = fuzzyCalculations.resolve(10,50,60,77);
    expect(a>b,true);
  });
  test('a must be greater than b', () {
    ///order of entries : (int _popularity , int _placevisited ,int _incidence,int _timeOfvisit)
    int a = fuzzyCalculations.resolve(25,50,63,77);
    int b = fuzzyCalculations.resolve(25,50,60,70);
    expect(a>b,true);
  });
  test('a must be greater than b', () {
    ///order of entries : (int _popularity , int _placevisited ,int _incidence,int _timeOfvisit)
    int a = fuzzyCalculations.resolve(25,50,63,77);
    int b = fuzzyCalculations.resolve(25,50,60,77);
    expect(a>b,true);
  });
  test('a must be greater than b', () {
    ///order of entries : (int _popularity , int _placevisited ,int _incidence,int _timeOfvisit)
    int a = fuzzyCalculations.resolve(27,50,65,77);
    int b = fuzzyCalculations.resolve(25,50,63,77);
    expect(a>b,true);
  });
  test('a must be greater than b', () {
    ///the incidence outweighs the popularity
    ///order of entries : (int _popularity , int _placevisited ,int _incidence,int _timeOfvisit)
    int a = fuzzyCalculations.resolve(25,55,90,77);
    int b = fuzzyCalculations.resolve(90,50,25,77);
    expect(a>b,true);
  });
  test('a must be equal to b', () {
    ///the weight of the number of places visited is equal to the weight of the duration of the visit
    ///order of entries : (int _popularity , int _placevisited ,int _incidence,int _timeOfvisit)
    int a = fuzzyCalculations.resolve(96,25,63,69);
    int b = fuzzyCalculations.resolve(96,69,63,25);
    expect(b==a,true);
  });
  test('cache should be empty when created', () {
    ///the weight of the number of places visited is less than the incidence
    ///order of entries : (int _popularity , int _placevisited ,int _incidence,int _timeOfvisit)
    int a = fuzzyCalculations.resolve(96,32,63,69);
    int b = fuzzyCalculations.resolve(96,63,32,69);
    expect(b<a,true);
  });
  test('b must be greater than a', () {
    ///in this case the weight of the duration of the visit is greater than the weight of the incidence
    ///order of entries : (int _popularity , int _placevisited ,int _incidence,int _timeOfvisit)
    int a = fuzzyCalculations.resolve(96,32,63,49);
    int b = fuzzyCalculations.resolve(96,32,49,63);
    expect(b>a,true);
  });
  test('a must be greater than b', () {
    ///here the weight of the incidence is greater than the duration of the visit
    ///order of entries : (int _popularity , int _placevisited ,int _incidence,int _timeOfvisit)
    int a = fuzzyCalculations.resolve(96,32,63,19);
    int b = fuzzyCalculations.resolve(96,32,19,63);
    expect(b<a,true);
  });
  test('b must be greater than a', () {
    ///order of entries : (int _popularity , int _placevisited ,int _incidence,int _timeOfvisit)
    int a = fuzzyCalculations.resolve(96,22,63,19);
    int b = fuzzyCalculations.resolve(22,96,63,19);
    expect(b>a,true);

  });


}