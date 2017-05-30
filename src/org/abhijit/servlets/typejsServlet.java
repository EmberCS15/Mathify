package org.abhijit.servlets;

import java.io.IOException;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.websocket.Session;

/**
 * Servlet implementation class typejsServlet
 */
@WebServlet(description = "text processor", urlPatterns = { "/typejsServlet" })
public class typejsServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		//TODO Auto-generated method stub
		//response.getWriter().append("Served at: ").append(request.getContextPath());
		String text = request.getParameter("usertext");
		Pattern pat = Pattern.compile("<br>");
		Matcher mat=pat.matcher(text);
		text = mat.replaceAll("@~");
		//System.out.println("The text is : "+text);
		HttpSession session = request.getSession();
		session.setAttribute("usertext", text);
		response.sendRedirect("./Parser.jsp");
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}
}
