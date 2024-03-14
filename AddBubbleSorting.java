import java.util.ArrayList;
import java.util.Scanner;

public class AddBubbleSortOfResults {
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


        ArrayList<Result> results = new ArrayList<>();
        for (int i = 0; i < lines.size(); i++) {
            String line = lines.get(i);
            int count = howManySubstrings(line, substring);
            results.add(new Result(count, i));
        }

        bubbleSort(results);

        for (Result result : results) {
            System.out.println(result.getCount() + " " + result.getIndex());
        }
    }

    // Підрахунок кількості входжень підрядка в рядок
    private static int howManySubstrings(String line, String substring) {
        int count = 0;
        int index = line.indexOf(substring);
        while (index != -1) {
            count++;
            index = line.indexOf(substring, index + 1);
        }
        return count;
    }

    // Зберігання кількості входжень та індексу рядка
    static class Result {
        private int count;
        private int index;
        public Result(int count, int index) {
            this.count = count; // кількість входжень підрядка
            this.index = index; // Індекс рядка
        }
        public int getCount() {
            return count;
        }
        public int getIndex() {
            return index;
        }
    }

    private static void bubbleSort(ArrayList<Result> results) {
        int n = results.size();
        for (int i = 0; i < n - 1; i++) {
            for (int j = 0; j < n - i - 1; j++) {
                if (results.get(j).getCount() > results.get(j + 1).getCount()) {
                    Result temp = results.get(j);
                    results.set(j, results.get(j + 1));
                    results.set(j + 1, temp);
                }
            }
        }
    }
}