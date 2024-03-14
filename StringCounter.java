import java.util.ArrayList;
import java.util.Scanner;

public class StringCounter {
    public static void main(String[] args) {
            Scanner scan = new Scanner(System.in);
        ArrayList<String> lines = new ArrayList<>();
        int maxlines = 100;
        int linescounter = 0;
        while (linescounter < maxlines && scan.hasNextLine()){
            String line = scan.nextLine();
            lines.add(line);
            linescounter++;
        }
    }
}
