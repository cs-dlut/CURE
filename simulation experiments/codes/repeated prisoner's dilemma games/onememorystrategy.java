

public class onememorystrategy {
	boolean decision;
	double score;
	public boolean onememorystrategy_decision(boolean decision_opp1, boolean decision_opp2,double[] p)
	{
		if(decision_opp1 && decision_opp2)
		{
			if(Math.random() < p[0])
				decision =true;
			else
				decision = false;
		}
		if(decision_opp1 && !decision_opp2)
		{
			if(Math.random() < p[1])
				decision =true;
			else
				decision = false;
		}
		if(!decision_opp1 && decision_opp2)
		{
			if(Math.random() < p[2])
				decision =true;
			else
				decision = false;
		}
		if(!decision_opp1 && !decision_opp2)
		{
			if(Math.random() < p[3])
				decision =true;
			else
				decision = false;
		}
		return decision;
	}
	public double onememorystrategy_score(boolean decision1, boolean decision2)
	{

		int R = 3;
		int S = 0;
		int T = 5;
		int P = 1;

		if(decision1)
		{
			if(decision2)
				score = R;
			else
				score = S;
			}
		else
		{
			if(decision2)
				score = T;
			else
				score = P;
			}

		return score;
	}
}
