
public class CURE {
	public boolean decision;
	public double score;
	int i=0,j=0; // initial
	int t = 1; //delta

	public boolean CURE_decision(boolean decision_opp1, boolean decision_opp2)
	{

		if(decision_opp1 && !decision_opp2)
			i+=1;
		if(decision_opp2 && !decision_opp1)
			j+=1;
		if(i -j > t)
		{
			  decision = false;
		}
		else
		{
			  decision = true;
		}
//		if(Math.random()<0.01)  // define the noise
//			decision = !decision;
		return decision;
	}

	public double CURE_score(boolean decision1, boolean decision2)
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
