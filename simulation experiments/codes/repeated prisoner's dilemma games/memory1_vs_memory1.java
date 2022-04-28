//package evolution.MemOneScore;//calculating the payoff between all 14641 and 14641 strategies
import java.io.FileWriter;
import java.io.IOException;
import java.nio.charset.Charset;
import com.csvreader.CsvReader;
import com.csvreader.CsvWriter;

import java.util.*;
public class memory1_vs_memory1 {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		double[] p = {0.01,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,0.99};
		int length = p.length;
		int size = (int)Math.pow(length, 4);
		double[][] strategy = new double[size][4];

		double[][] score = new double[size][size];

		int R=3,S=0,T=5,P=1;
		double[][] D1 = new double[4][4],D2 = new double[4][4],D3 = new double[4][4];
		double[] X= new double[4],Y =new double[4];
	    double score_X,score_Y;
	    double determinant1,determinant2,determinant3;
	    long num=0;

		System.out.println("");
		int l=0;
		for(int i=0;i<length;i++)
			for(int j=0;j<length;j++)
				for(int h=0;h<length;h++)
					for(int k=0;k<length;k++)
						{
						strategy[l][0] = p[i];
						strategy[l][1] = p[j];
						strategy[l][2] = p[h];
						strategy[l][3] = p[k];
						l++;
						}

		for(int j=0;j<size;j++)
		{
			for(int k=0;k<=j;k++)
			{

				for(int i=0;i<4;i++)
				{
					X[i] = strategy[j][i];
					Y[i] = strategy[k][i];
				}

				D1[0][0] = -1+X[0]*Y[0]; D2[0][0] = -1+X[0]*Y[0];
				D1[0][1] = -1+X[0]; 	 D2[0][1] = -1+X[0];
				D1[0][2] = -1+Y[0];		 D2[0][2] = -1+Y[0];
				D1[0][3] = R; D1[1][3] = S;D1[2][3] = T;D1[3][3] = P;
				D2[0][3] = 1;D2[1][3] = 1;D2[2][3] = 1;D2[3][3] = 1;
				D1[1][0] = X[1]*Y[2];	 D2[1][0] = X[1]*Y[2];
				D1[1][1] = -1+X[1];		 D2[1][1] = -1+X[1];
				D1[1][2] = Y[2];		 D2[1][2] = Y[2];
				D1[2][0] = X[2]*Y[1];	 D2[2][0] = X[2]*Y[1];
				D1[2][1] = X[2];		 D2[2][1] = X[2];
				D1[2][2] = -1+Y[1];		 D2[2][2] = -1+Y[1];
				D1[3][0] = X[3]*Y[3];	 D2[3][0] = X[3]*Y[3];
				D1[3][1] = X[3];		 D2[3][1] = X[3];
				D1[3][2] = Y[3];		 D2[3][2] = Y[3];

				D3[0][0] = -1+X[0]*Y[0];
				D3[0][1] = -1+X[0];
				D3[0][2] = -1+Y[0];
				D3[0][3] = R; D3[1][3] = T;D3[2][3] = S;D3[3][3] = P;
				D3[1][0] = X[1]*Y[2];
				D3[1][1] = -1+X[1];
				D3[1][2] = Y[2];
				D3[2][0] = X[2]*Y[1];
				D3[2][1] = X[2];
				D3[2][2] = -1+Y[1];
				D3[3][0] = X[3]*Y[3];
				D3[3][1] = X[3];
				D3[3][2] = Y[3];

				determinant1 = Fun(4,D1);
				determinant2 = Fun(4,D2);
				determinant3 = Fun(4,D3);
				score_X = determinant1/determinant2;
				score_Y = determinant3/determinant2;
				score[j][k] = score_X;
				score[k][j] = score_Y;

				num ++;
				System.out.println(num+ " "+score_X +" "+score_Y);

			}
		}

		    String path = "C:\\payoff\\"+"14641-14641_3R_01score.csv";

			try
			{
				writeCSV(score, path);
			}
			catch (Exception e)
			{
				e.printStackTrace();
			}

	}

	static double Fun( int n, double[][] D )
	{
	    double[][] b ;
	    int i = 0, j = 0; double value = 0;
	    int x = 0,c = 0,p=0;

	    if(n == 1)
	    	return D[0][0];
	    for(i = 0;i < n; i++)
	    {
	    	b = new double[n-1][n-1];
	        for(c = 0;c < n-1; c++)
	        {
	            for(j = 0;j < n-1;j++)
	            {
	                if (c < i){
	                    p = 0;
	                }
	                else{
	                    p = 1;
	                }
	            b[c][j] = D[c+p][j+1];
	            }
	        }

	        if(i % 2 == 0){
	            x = 1;
	        }
	        else{
	            x = (-1);
	        }
	     value += D[i][0] * Fun(n - 1, b ) * x;
	    }

	    return value;
	}


	public static void writeCSV(double [][] data, String csvFilePath) throws Exception
	{
		CsvWriter csvWriter = new CsvWriter(csvFilePath, ',', Charset.forName("SJIS"));
		int i, j;
		int sum=0;
		for (i = 0; i < data.length; i++)//14641ÐÐ
		{
			String [] rowContent = new String[data[0].length];
			for (j = 0; j < data[0].length; j++)//14641ÁÐ
			{
				rowContent[j] = (String)(""+data[i][j]);
				System.out.println(sum);
				sum ++;
			}
			csvWriter.writeRecord(rowContent);
		}
	    csvWriter.close();
	}
}


