export type BlogTag = {
	id: number;
	name: string;
	count: number;
};

export type BlogItem = {
	id: string;
	title: string;
	content: string;
	description?: string;
	author: string;
	header_image_url?: string;
	published_at: string;
	tags: string[];
};
