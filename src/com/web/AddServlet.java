package com.web;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Blob;
import java.sql.SQLException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.cfg.Configuration;
import org.hibernate.engine.jdbc.BlobProxy;

import database.ProductDetails;

@SuppressWarnings({ "deprecation", "rawtypes", "unchecked" })
@MultipartConfig(maxFileSize = 1000000)
public class AddServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public AddServlet() {
		super();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		response.getWriter().append("Served at: ").append(request.getContextPath());
		int pid;
		String title = request.getParameter("title");
		int quantity = Integer.parseInt(request.getParameter("quantity"));
		int size = Integer.parseInt(request.getParameter("size"));
		Part part = request.getPart("image");
		InputStream is = part.getInputStream();

		SessionFactory factory = new Configuration().configure("product.cfg.xml").buildSessionFactory();
		Session dbsession = factory.openSession();

		String query = "select max(pid) from ProductDetails";
		Query q = dbsession.createQuery(query);
		List<Integer> ls = q.list();
		if (ls.get(0) == null) {
			pid = 1;
		} else {
			pid = ls.get(0);
			pid++;
		}

		String query2 = "select image from ProductDetails";
		Query q2 = dbsession.createQuery(query2);
		List<Blob> ls2 = q2.list();
		double totalSize = 0.0;
		for (Blob bl : ls2) {
			try {
				totalSize += ((((double) bl.length()) / 1024) / 1024);
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		if (totalSize <= 10) {
			Transaction tx = dbsession.beginTransaction();
			ProductDetails temp = new ProductDetails(pid, title, quantity, size,
					BlobProxy.generateProxy(is, is.available()));
			dbsession.saveOrUpdate(temp);
			tx.commit();
		} else {
			HttpSession session = request.getSession();
			session.setAttribute("invalid", "<div id=\"invalid\"class=\"alert alert-danger\" role=\"alert\">\r\n"
					+ "					<span>Image database size is full!</span></div>");

		}
		dbsession.close();
		factory.close();

		response.sendRedirect("index.jsp");
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);

	}

}
