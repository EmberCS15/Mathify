<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.util.*,java.io.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
<!-- State the functions here -->
<%! 
static String formatted=""; 
static String text="";
static int pos_start=0;
static List<String> simple_op = null;
static List<String> operators = null;
static List<String> vectors = null;
static List<String> symbols = null;
static List<Integer> unicodes = null;

public String[] addTags(String[] params){
	String []p = new String[params.length];
	for(int itr=0;itr<params.length;itr++){
		p[itr]="<mrow>";
		for(int j=0;j<params[itr].length();j++){
			char ch = params[itr].charAt(j);
			ch = Character.toLowerCase(ch);
			if((ch>=97 && ch<=122)||symbols.contains(""+ch)){
				p[itr]+="<mi>"+params[itr].charAt(j)+"</mi>";
			}else if(simple_op.contains(""+ch)||ch==')'||ch=='('){
				p[itr]+="<mo>"+params[itr].charAt(j)+"</mo>";	
			}else{
				p[itr]+="<mn>"+params[itr].charAt(j)+"</mn>";
			}
		}
		p[itr]+="</mrow>";
	}
	return p;
}
public void getType(char ch){
	ch=Character.toLowerCase(ch);
	if(ch>=97 && ch<=122){
		formatted+="<mi>"+ch+"</mi>";
	}
	else if(simple_op.contains(""+ch)){
		formatted+="<mo>"+ch+"</mo>";
	}else if(ch>=48&&ch<=58){
		formatted+="<mn>"+ch+"</mn>";
	}
}	

//Must Find a better method to determine the position of the bracket ). I have simply parsed back ^200 5spaces.
public int getNumerator(int i,int j){
	int start;
	int brackets = 0;
	System.out.println("The value of i = "+i);
	//System.out.print("The value of length: "+i+"charAt(i-1) : "+formatted.charAt(i-1)+" and the string is "+formatted.substring(i-10,i));
	if(text.charAt(j-1)!=')'){
		start = i-10;
	}else{
		i-=11;
		brackets = 1;
		/*while(formatted.charAt(i) != '(')
				i--;*/
		while(i>=0&&brackets!=0){
			if(formatted.charAt(i)==')'||formatted.charAt(i)=='(')
				brackets = (formatted.charAt(i) == ')')?brackets+1:brackets-1;
			if(brackets == 0)
				break;
			i--;
		}
		start = i-4;
	}
	//System.out.println("The substring text is : "+formatted.substring(start-11,start));
	System.out.print("The value of start: "+start);
	return start;
}
%>

<!-- State the entire code here -->
<% 
//Text to be parsed
text = (String)session.getAttribute("usertext") ;
//System.out.println("The text is : "+text);
//Final Html Code Generated

//all modes to be stated here such as <munderover>
int munderover=0,division=0,power=0,text_mode=0,square_root=0;

//List of all the variables specific to modes . this is for munderover
//String up_lim,lw_lim;
//int brackets=0;

//Creating a map to keep track of the brackets of power and Division(Add any other element whose brackets are to be tracked and create the corresponding code)
//Creating a stack of functions which require bracket tracking
HashMap<String,Integer> map = new HashMap<String,Integer>();
ArrayList<String> stack = new ArrayList<String>();
map.put("division",0);
map.put("power",0);
map.put("square_root",0);
		
//List of all the operations without unicodes
String bodmas[] = {"+","-","*"," ","%","!","log","ln","="};
String op[]={"&mp;","&pm;","&hbar;","&exist;","&forall;",
		"&iff;","&Rightarrow;","&ne;","&ap;","&sim;","&cong;","&propto;","&wedgeq;","&lt;","&leq;","&ll;","&gt;",
		"&geq;","&gg;","&middot;","&times;","&compfn;","&div;","&setminus;","&oplus;","&cap;","&cup;","&subset;"};

//List of all opeartions using unicodes which qualify super and subscripts such as sigma
//Code point for square root is 8730
Integer[] uni={8721,8719,8747,67,80,8730};
//List of all The Symbols . CONVERT TO UNICODE
String[] sym = {"&alpha;","&pi;","&infin;","&emptyset;","&naturals;","&integers;","&rationals;","&reals;","&complexes;","&Theta;"};

//List of ALl the Vectors . CONVERT TO UNICODE
String v[] = {"&rharu;","&rarr;","&tilde;","_"};

operators = Arrays.asList(op);
vectors = Arrays.asList(v);
symbols = Arrays.asList(sym);
unicodes = Arrays.asList(uni);
simple_op = Arrays.asList(bodmas);

int i;

// How to make File Name unique
File f= new File("input.txt");
f.createNewFile();
FileWriter fw=new FileWriter(f);
BufferedWriter bw = new BufferedWriter(fw);
bw.write(text);
bw.close();
//InputFile created

File fout= new File("output.html");
fout.createNewFile();
fw = new FileWriter(fout);
bw = new BufferedWriter(fw);

//Initiating the Formatted String
formatted = "<!DOCTYPE html>\n<html lang='en'>\n<head><title>Result TypedJS</title><meta charset='UTF-8'><meta name='viewport' content='width=device-width, initial-scale=1.0'>"
    +"<script src='https://ajax.googleapis.com/ajax/libs/jquery/3.1.0/jquery.min.js'></script>"
    +"<script src='https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js' integrity='sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa' crossorigin='anonymous'></script>"
    +"<link rel='stylesheet' href='https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css' integrity='sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u' crossorigin='anonymous'>"
    +"<link rel='stylesheet' href='https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap-theme.min.css' integrity='sha384-rHyoN1iRsVXV4nD0JutlnGaslCJuC7uwjduW9SVrLvRYooPp2bWYgmgJQIXwl/Sp' crossorigin='anonymous'>"
    +"<link rel='stylesheet' type='text/css' href='./css/styling.css'>"
    +"<script type='text/javascript' async src='https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.1/MathJax.js?...'></script>"
    +"<script type='text/javascript' src='http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_SVG'></script>"
    +"<script rel='text/javascript' src='./js/typed.js'></script></head>\n<body>";
formatted+="<button id='btn_play' name='IncreaseSpeed' onclick='startAnimation(this)'>Play</button>&nbsp;&nbsp;<button id='btn_down' name='DecreaseSpeed' onclick='controlSpeed(100,1)'>Speed Down</button>&nbsp;&nbsp;<button id='btn_up' name='IncreaseSpeed' onclick='controlSpeed(100,-1)'>Speed Up</button>&nbsp;&nbsp;<button id='btn_stop' name='pause' onclick='Pause()'>Pause</button>&nbsp;&nbsp;<button id='btn_start' name='resume' onclick='Resume()'>Resume</button>";
formatted+="<br>\n<div id='typed-strings' hidden>\n<p>\n<math xmlns='http://www.w3.org/1998/Math/MathML'>";
pos_start = formatted.length();
//Writing to the File Using the HTML Conventions
//Check if function returns Formatted String
for(i=0;i<text.length();i++){
	if(text_mode == 1){
		if(text.charAt(i)=='#'){
			text_mode = 0;
			formatted+="</mtext>";
		}
		else formatted += text.charAt(i);
	}else if(simple_op.contains(""+text.charAt(i))){
		//System.out.println("Here");
		formatted+="<mo>"+text.charAt(i)+"</mo>";
	}else{
		switch(text.charAt(i)){
			case '^':int start=getNumerator(formatted.length(),i);
					power = 1;
					map.put("power",0);
					stack.add("power");
					String t = formatted.substring(0,start);
					t += "<msup><mrow>"+formatted.substring(start,formatted.length())+"</mrow><mrow>";
					System.out.println("\nThe value of Start is POWER:"+t);
					formatted = t;
					if(text.charAt(i+1)!='('){
						getType(text.charAt(i+1));
						formatted += "</mrow></msup>";
						stack.remove(stack.size()-1);
						power = 0 ;
						i++;
					}
					break;
			case '&':int index = text.substring(i).indexOf(";");
					System.out.println("The index is "+(i+index)+" and Substring : "+text.substring(i, i+index+1));
					if(operators.contains(text.substring(i, i+index+1))){
						formatted+="<mo>"+text.substring(i, i+index+1)+"</mo>";
					}
					else if(symbols.contains(text.substring(i, i+index+1))){
						formatted+="<mi>"+text.substring(i, i+index+1)+"</mi>";
					}
					else if(vectors.contains(text.substring(i, i+index+1))){
						formatted+="<mover><mi>"+text.charAt(i-1)+"</mi><mo>"+text.substring(i, i+index+1)+"</mo></mover>";
					}
					i+=index;
					//formatted+="^200 ";
					break;
			case '/':int startIndex = getNumerator(formatted.length(),i);
					stack.add("division");
					map.put("division",0);
					//brackets = 0;
					division = 1;
					String temp = formatted.substring(0,startIndex);
					//System.out.println("\nThe value of StartIndex is :"+startIndex);
					temp += "<mfrac><mrow>"+formatted.substring(startIndex,formatted.length())+"</mrow><mrow>";
					formatted = temp;
					if(text.charAt(i+1)!='('){
						getType(text.charAt(i+1));
						formatted += "</mrow></mfrac>";
						stack.remove(stack.size()-1);
						division = 0;
						i++;
					}
					break;
			case '#':text_mode = 1;
					formatted+="<mtext>";
					break;
			default:if(i!=text.length()-1 && text.charAt(i)=='@' && text.charAt(i+1) == '~'){
						formatted+="<mspace linebreak='newline'>";
						i++;
						continue;
					}
					if(i==text.length()-1 || text.charAt(i+1)!='&'){
						int code = text.codePointAt(i);
						//System.out.print(code+" ");
						if(unicodes.contains(code)){
							if(code == 8730){
								formatted+="<msqrt><mrow>";
								map.put("square_root",0);
								stack.add("square_root");
								square_root=1;
								continue;
							}
							//Permutation and Combination
							else if(code == 67 || code == 80){
								String field = text.substring(i+2,i+2+text.substring(i+2).indexOf(")"));
								String []params = field.split(",");
								char ch=(code == 67)?'C':'P';
								formatted+="<munderover><mo>"+ch+"</mo><mn>"+params[0].trim()+"</mn><mn>"+params[1].trim()+"</mn></munderover>";
								i=i+2+text.substring(i+2).indexOf(")");
								continue;
							}
							munderover=1;
							formatted+="<munderover><mo>" + text.charAt(i) + "</mo>";
							String field = text.substring(i+2,i+2+text.substring(i+2).indexOf(")"));
							String []params = field.split(",");
							params = addTags(params);
							formatted+=params[0].trim()+params[1].trim()+"</munderover>";
							i=i+2+text.substring(i+2).indexOf(")");
							//i=i+1;//Potential Region of error put this as one ) bracket was comming after the operator symbols
							munderover=0;
						}
						else if(stack.size()!=0 && (text.charAt(i)==')' || text.charAt(i)=='(')){
							//brackets = (text.charAt(i)==')')?brackets+1:brackets-1;
							if(division == 1){
								int brackets = map.get("division");
								brackets = (text.charAt(i)=='(')?brackets+1:brackets-1;
								map.put("division",brackets);
							}
							if(power == 1){
								int brackets = map.get("power");
								brackets = (text.charAt(i)=='(')?brackets+1:brackets-1;
								map.put("power",brackets);							
							}
							if(square_root == 1){
								int brackets = map.get("square_root");
								brackets = (text.charAt(i) == '(')?brackets+1:brackets-1;
								map.put("square_root",brackets);
							}
							formatted+="<mo>"+text.charAt(i)+"</mo>";
							int itr = stack.size()-1;
							while(itr>=0 ){
								if(map.get(stack.get(itr))==0){
									String rem = stack.get(itr);
									if(rem.equals("power")){
										formatted+="</mrow></msup>";
										power=0;
									}else if(rem.equals("division")){
										formatted+="</mrow></mfrac>";
										division=0;
									}else if(rem.equals("square_root")){
										formatted+="</mrow></msqrt>";
										square_root = 0;
									}
									stack.remove(itr);
								}
								itr--;
							}
						}else{
							char ch = text.charAt(i);
							//System.out.println("Reached Here" + ch);
							ch=Character.toLowerCase(ch);
							if(ch>=97 && ch<=122){
								formatted+="<mi>"+text.charAt(i)+"</mi>";
							}else if(text.charAt(i)>=48 && text.charAt(i)<=58){
								formatted+="<mn>"+text.charAt(i)+"</mn>";
							}else if(text.charAt(i)==')' || text.charAt(i)=='('){
								formatted+="<mo>"+text.charAt(i)+"</mo>";		
							}
						}
					}
					else if(text.charAt(i+1) == '&'){
						int indx = text.substring(i+1).indexOf(";")+1;
						//System.out.println("The index is::"+indx+ "substring : "+text.substring(i+1,i+1+indx));
						String checker = text.substring(i+1,i+1+indx);
						if(!vectors.contains(checker)){
							char ch = text.charAt(i);
							//System.out.println("Reached Here" + ch);
							ch=Character.toLowerCase(ch);
							if(ch>=97 && ch<=122){
								formatted+="<mi>"+text.charAt(i)+"</mi>";
							}else if(text.charAt(i)>=48 && text.charAt(i)<=58){
								formatted+="<mn>"+text.charAt(i)+"</mn>";
							}else if(text.charAt(i)==')' || text.charAt(i)=='('){
								formatted+="<mo>"+text.charAt(i)+"</mo>";		
							}
						}
					}
					
		}
	}
}
formatted+="</math>\n</p>\n</div>\n<span id='typed'></span>\n";
formatted+="<script type='text/javascript'>/*document.addEventListener('DOMContentLoaded', function(){Typed.new('#typed', {stringsElement: document.getElementById('typed-strings'),typeSpeed : 150});});*/function startAnimation(element){Typed.new('#typed', {stringsElement: document.getElementById('typed-strings'),typeSpeed: -50});element.setAttribute('disabled',true);}function controlSpeed(decrement,flag){Typed.controlSpeed(decrement,flag);}function Pause(){Typed.pauseAnimation(1);}function Resume(){Typed.resumeAnimation(0);}"+"</script>\n";
formatted+="</body>\n</html>";
bw.write(formatted);
bw.close();
%>
<h1>Success : File Written</h1>
</body>
</html>

<!--  List of Problems 
	- In MAthML on tags specific to it can be used.No other tags are allowed.
	- Getting Invalid Markup Warning during the animations
	- # has to be Used for text #
	- for Summation , Product , Integral , Combination , Permuatation Arguments must be Given in Brackets
	- Sum,Prod,Integral , Combination ,  Permutation  ------  Sym( arg1, arg2)
	- One Convention states that '/' can only be used for division and only brackets which will not create problem are () 
-->