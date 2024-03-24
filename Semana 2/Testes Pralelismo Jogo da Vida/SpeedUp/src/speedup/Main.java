/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package speedup;

//import JSci.maths.matrices.*;
import JSci.maths.vectors.*;
import java.lang.Math.*;
/**
 *
 * @author sperotto
 */
public class Main {
    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {

    AbstractDoubleVector T1;
    AbstractDoubleVector T2;
    AbstractDoubleVector T3;
    AbstractDoubleVector T4;
    AbstractDoubleVector T5;
    AbstractDoubleVector T6;
    AbstractDoubleVector T7;
    AbstractDoubleVector T8;
    
    AbstractDoubleVector S1;
    AbstractDoubleVector S2;
    AbstractDoubleVector S3;
    AbstractDoubleVector S4;
    AbstractDoubleVector S5;
    AbstractDoubleVector S6;
    AbstractDoubleVector S7;
    AbstractDoubleVector S8;
    
    AbstractDoubleVector E1;
    AbstractDoubleVector E2;
    AbstractDoubleVector E3;
    AbstractDoubleVector E4;
    AbstractDoubleVector E5;
    AbstractDoubleVector E6;
    AbstractDoubleVector E7;
    AbstractDoubleVector E8;
    
    int Tamanho=6;
    int i=0;
        T1 = new DoubleVector(Tamanho);
        T2 = new DoubleVector(Tamanho);
        T3 = new DoubleVector(Tamanho);
        T4 = new DoubleVector(Tamanho);
        T5 = new DoubleVector(Tamanho);
        T6 = new DoubleVector(Tamanho);
        T7 = new DoubleVector(Tamanho);
        T8 = new DoubleVector(Tamanho);
        
        S1 = new DoubleVector(Tamanho);
        S2 = new DoubleVector(Tamanho);
        S3 = new DoubleVector(Tamanho);
        S4 = new DoubleVector(Tamanho);
        S5 = new DoubleVector(Tamanho);
        S6 = new DoubleVector(Tamanho);
        S7 = new DoubleVector(Tamanho);
        S8 = new DoubleVector(Tamanho);
        
        E1 = new DoubleVector(Tamanho);
        E2 = new DoubleVector(Tamanho);
        E3 = new DoubleVector(Tamanho);
        E4 = new DoubleVector(Tamanho);
        E5 = new DoubleVector(Tamanho);
        E6 = new DoubleVector(Tamanho);
        E7 = new DoubleVector(Tamanho);
        E8 = new DoubleVector(Tamanho);
        
        T1.setComponent(0,0.00746);
        T1.setComponent(1,0.06242);
        T1.setComponent(2,0.51075);
        T1.setComponent(3,4.13413);
        T1.setComponent(4,33.30424);
        T1.setComponent(5,268.25574);
        
        T2.setComponent(0,0.00382);
        T2.setComponent(1,0.03141);
        T2.setComponent(2,0.25610);
        T2.setComponent(3,2.06827);
        T2.setComponent(4,16.65677);
        T2.setComponent(5,134.10254);
        
        T3.setComponent(0,0.00271);
        T3.setComponent(1,0.02162);
        T3.setComponent(2,0.17262);
        T3.setComponent(3,1.38966);
        T3.setComponent(4,11.12755);
        T3.setComponent(5,89.45499);
        
        T4.setComponent(0,0.002056);
        T4.setComponent(1,0.01598);
        T4.setComponent(2,0.12883);
        T4.setComponent(3,1.03632);
        T4.setComponent(4,8.32924);
        T4.setComponent(5,66.88194);
        
        T5.setComponent(0,0.00183);
        T5.setComponent(1,0.01318);
        T5.setComponent(2,0.10492);
        T5.setComponent(3,0.84109);
        T5.setComponent(4,6.70102);
        T5.setComponent(5,53.50698);
        
        T6.setComponent(0,0.00158);
        T6.setComponent(1,0.01122);
        T6.setComponent(2,0.08887);
        T6.setComponent(3,0.6977);
        T6.setComponent(4,5.59869);
        T6.setComponent(5,44.6334);
       
        T7.setComponent(0,0.00140);
        T7.setComponent(1,0.00996);
        T7.setComponent(2,0.0767);
        T7.setComponent(3,0.6011);
        T7.setComponent(4,4.81348);
        T7.setComponent(5,38.36774);
       
        T8.setComponent(0, 0.00140);
        T8.setComponent(1,0.00857);
        T8.setComponent(2,0.06557);
        T8.setComponent(3,0.52139);
        T8.setComponent(4,4.1730);
        T8.setComponent(5,33.41928);
        
        
        for(i = 0; i <= 5; i++ ){
           S2.setComponent(i, ((T1.getComponent(i))/(T2.getComponent(i))));
           S3.setComponent(i, ((T1.getComponent(i))/(T3.getComponent(i))));
           S4.setComponent(i, ((T1.getComponent(i))/(T4.getComponent(i))));
           S5.setComponent(i, ((T1.getComponent(i))/(T5.getComponent(i))));
           S6.setComponent(i, ((T1.getComponent(i))/(T6.getComponent(i))));
           S7.setComponent(i, ((T1.getComponent(i))/(T7.getComponent(i))));
           S8.setComponent(i, ((T1.getComponent(i))/(T8.getComponent(i))));
      }
         for(i = 0; i <= 5; i++ ){
           E2.setComponent(i, ((S2.getComponent(i))/2));
           E3.setComponent(i, ((S3.getComponent(i))/3));
           E4.setComponent(i, ((S4.getComponent(i))/4));
           E5.setComponent(i, ((S5.getComponent(i))/5));
           E6.setComponent(i, ((S6.getComponent(i))/6));
           E7.setComponent(i, ((S7.getComponent(i))/7));
           E8.setComponent(i, ((S8.getComponent(i))/8));
      }

        for(i = 0; i <= 5; i++ ){
           System.out.println("S2["+(int)(Math.pow(2, i+5))+"]: "+S2.getComponent(i));
           System.out.println("E2["+(int)(Math.pow(2, i+5))+"]: "+E2.getComponent(i));
         //  System.out.println("\n");
      }
        for(i = 0; i <= 5; i++ ){
           System.out.println("S3["+(int)(Math.pow(2, i+5))+"]: "+S3.getComponent(i));
           System.out.println("E3["+(int)(Math.pow(2, i+5))+"]: "+E3.getComponent(i));
         //  System.out.println("\n");
      }
        for(i = 0; i <= 5; i++ ){
           System.out.println("S4["+(int)(Math.pow(2, i+5))+"]: "+S4.getComponent(i));
           System.out.println("E4["+(int)(Math.pow(2, i+5))+"]: "+E4.getComponent(i));
          // System.out.println("\n");
      }
        for(i = 0; i <= 5; i++ ){
           System.out.println("S5["+(int)(Math.pow(2, i+5))+"]: "+S5.getComponent(i));
           System.out.println("E5["+(int)(Math.pow(2, i+5))+"]: "+E5.getComponent(i));
         //  System.out.println("\n");
      }
        for(i = 0; i <= 5; i++ ){
           System.out.println("S6["+(int)(Math.pow(2, i+5))+"]: "+S6.getComponent(i));
           System.out.println("E6["+(int)(Math.pow(2, i+5))+"]: "+E6.getComponent(i));
         //  System.out.println("\n");
      }
        for(i = 0; i <= 5; i++ ){
           System.out.println("S7["+(int)(Math.pow(2, i+5))+"]: "+S7.getComponent(i));
           System.out.println("E7["+(int)(Math.pow(2, i+5))+"]: "+E7.getComponent(i));
          // System.out.println("\n");
      }
        for(i = 0; i <= 5; i++ ){
           System.out.println("S8["+(int)(Math.pow(2, i+5))+"]: "+S8.getComponent(i));
           System.out.println("E8["+(int)(Math.pow(2, i+5))+"]: "+E8.getComponent(i));
           //System.out.println("\n");
      }

    }

}
