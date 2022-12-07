package database;

import java.sql.Blob;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Lob;

@Entity
public class ProductDetails {

	@Id
	@Column(length = 6)
	private int pid;

	@Column(length = 30)
	private String title;

	@Column(length = 4)
	private int quantity;

	@Column(length = 3)
	private int size;

	@Lob
	private Blob image;

	public ProductDetails() {
		super();
		// TODO Auto-generated constructor stub
	}

	public ProductDetails(int pid, String title, int quantity, int size, Blob image) {
		super();
		this.pid = pid;
		this.title = title;
		this.quantity = quantity;
		this.size = size;
		this.image = image;
	}

	public int getPid() {
		return pid;
	}

	public void setPid(int pid) {
		this.pid = pid;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public int getQuantity() {
		return quantity;
	}

	public void setQuantity(int quantity) {
		this.quantity = quantity;
	}

	public int getSize() {
		return size;
	}

	public void setSize(int size) {
		this.size = size;
	}

	public Blob getImage() {
		return image;
	}

	public void setImage(Blob image) {
		this.image = image;
	}

}
