package com.web;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;

import database.LoginDetails;

@SuppressWarnings({ "deprecation", "rawtypes", "unchecked" })
public class LoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public LoginServlet() {
		super();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		response.getWriter().append("Served at: ").append(request.getContextPath());
		String username = request.getParameter("uname");
		String password = request.getParameter("pass");

		SessionFactory factory = new Configuration().configure("login.cfg.xml").buildSessionFactory();
		Session dbsession = factory.openSession();
		String query = "from LoginDetails where username=:uname and password=:pass";
		Query q = dbsession.createQuery(query);
		q.setParameter("uname", username);
		q.setParameter("pass", password);

		List<LoginDetails> ls = q.list();
		if (ls.isEmpty()) {
			HttpSession session = request.getSession();
			session.setAttribute("invalid",
					"<div id=\"invalid\"class=\"alert alert-danger\" role=\"alert\">\r\n"
							+ "					<span>Invalid username or password! Try again.</span>\r\n"
							+ "				</div>");
			response.sendRedirect("login.jsp");
		} else {
			HttpSession session = request.getSession();
			session.setAttribute("username", username);
			response.sendRedirect("index.jsp");
		}
		dbsession.close();
		factory.close();
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doGet(request, response);
	}

}
