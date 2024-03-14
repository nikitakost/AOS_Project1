import java.util.ArrayList;
import java.util.Scanner;

public class SubStringCounter {
    public static void main(String[] args) {
        if (args.length < 1) {
            System.out.println("Передайте аргумент командного рядка <substring>");
            return;
        }

        String substring = args[0];
        Scanner scan = new Scanner(System.in);
        ArrayList<String> lines = new ArrayList<>();
        int maxlines = 100;
        int linescounter = 0;
        while (linescounter < maxlines && scan.hasNextLine()) {
            String line = scan.nextLine();
            lines.add(line);
            linescounter++;
        }

        // Пошук входжень підрядка в кожному рядку
        for (int i = 0; i < lines.size(); i++) {
            String line = lines.get(i);
            int count = howManySubstrings(line, substring);
            System.out.println(count + " " + i);
        }
    }

    // Підрахунку кількості входжень підрядка в рядок
    private static int howManySubstrings(String line, String substring) {
        int count = 0;
        int index = line.indexOf(substring);
        while (index != -1) {
            count++;
            index = line.indexOf(substring, index + 1);
        }
        return count;
    }
}
