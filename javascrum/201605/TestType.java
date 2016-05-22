import java.util.*;

public class TestType {
   public static void main(String [] args) {
      ArrayList<Dog> dogs1 = new ArrayList<Animal>();
      ArrayList<Animal> animal1 = new ArrayList<Dog>();
      ArrayList<Dog> dogs = new ArrayList<Dog>();
      ArrayList<Animal> animals = dogs;
      ArrayList<Object> objs = new ArrayList<Dog>();

      List<Animal> list = new ArrayList<Animal>();
      List<Dog> dogList = dogs;
      ArrayList<Object> objects = new ArrayList<Object>();
      List<Object> objList = objects;
   }
}

class Animal {}
class Dog extends Animal {}
