

import java.io.BufferedWriter;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;

public class game_CURE_vs_CURE {

	public static double rewarding;
	public static void main(String[] args) throws IOException {
		// TODO Auto-generated method stub
		int round =10000000,times =1000;
		boolean decision_1, decision_2, decision_3, decision_4;
		double score_1, score_2,score_3,score_4;
		double score_CURE1,score_CURE2;
		int num=0;
		BufferedWriter out = null;
		try {
			out = new BufferedWriter(new OutputStreamWriter(new FileOutputStream("C:\\eclipse-workspace\\CURE\\payoff_CURE-CURE_noise=01_R.txt", true)));
			out.write("CURE1"+" "+"CURE2"+"\r\n");
		} catch (Exception e) {
			e.printStackTrace();
		}

			score_3=0;
			score_4=0;
			for(int j=0;j<times;j++)
			{
				CURE player1 = new CURE();
				CURE player2 = new CURE();
				score_1 =0;
				score_2 =0;
				player1.decision = true;
				player2.decision = true;

				for(int k=0;k<round;k++)
				{
					decision_3 = player1.decision;
					decision_4 = player2.decision;
					if(Math.random()<0.01) // define the noise
						decision_3 =!decision_3;
					if(Math.random()<0.01)  // define the noise
						decision_4 =!decision_4;

					score_1 += player1.CURE_score(decision_3, decision_4);
					score_2 += player2.CURE_score(decision_4, decision_3);


					decision_1 = player1.CURE_decision(decision_3, decision_4);
					decision_2 = player2.CURE_decision(decision_4,decision_3);

					player1.decision = decision_1;
					player2.decision = decision_2;

				}
				System.out.println(num);
				num++;
				score_1 = score_1/(double)round;
				score_2 = score_2/(double)round;
				score_3 += score_1;
				score_4 += score_2;

			}

			score_CURE1 = score_3/times;
			score_CURE2 = score_4/times;
			System.out.println(score_CURE1+" "+score_CURE2);
			out.write(score_CURE1+" "+score_CURE2+"\r\n");

				try {
					out.close();
					} catch (IOException e) {
					e.printStackTrace();
					}
	}
}
